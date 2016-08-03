require File.expand_path "../place_bid", __FILE__

class AuctionSocket
    def initialize app
        @app = app
        @clients = []
    end

    def call env
        @env = env
        if socket_request?
            socket = spawn_socket
            @clients << socket
            socket.rack_response
        else
            @app.call env
        end
    end

    private

    attr_reader :env

    def socket_request?
        Faye::WebSocket.websocket? env
    end

    def spawn_socket
        socket = Faye::WebSocket.new env
        socket.on :open do
            socket.send "Socket open!"
        end

        socket.on :message do |event|
            socket.send event.data
            begin
                message = ActiveSupport::JSON.decode(event.data)
                case message["action"]
                    when "bid"
                        bid socket, message
                        @auction = Auction.find  message["auction_id"].to_i
                        @robots = @auction.active_robots
                        if @robots.size >=1
                            @robots.each do |robot|
                                if robot.ends_at >= Time.now && robot.units > 1
                                    message["robot_id"] = robot.id
                                    active_robot socket, message
                                end
                            end

                        end
                    when "chat"
                        chat socket, message
=begin
                        r1 = @robots.first
                        r2 = @robots.last

                        #@robots.each do |robot|
                        #  while robot.ends_at >= Time.now && robot.units >= 1 do
                        message["robot_id"] = r1.id
                        active_robot socket, message
                        message["robot_id"] = r2.id
                        active_robot socket, message
=end

                    #tokens[2] = robot.id
                    #end
                end

                if message["message"] == "createrobotok"
                    message["message"] = "bidok"
                    socket.send message
                    notify_outbids socket,  message["value"] ,   message["ench"],   message["user_id"] , message["units_robot"] ,message["disable_robot_id"]
                end

            rescue Exception => e
                p e
                p e.backtrace
            end
        end

        socket
    end

    def bid socket, message
        service = PlaceBid.new
        if service.execute auction_id: message["auction_id"],  user_id: message["user_id"]
            reponse = {
                :message => 'bidok',
                :value => service.value,
                :units => service.units,
                :ench => service.nb_ench,
                :user_id => service.user.id,
                :units_robot => service.units_robot
            }.to_json
            socket.send reponse
            notify_outbids socket, service.value , service.nb_ench, service.user.id , -1,nil
        else
            if service.status == :won
                notify_auction_ended socket
            end
        end
    end

    def active_robot socket, message
        service = PlaceBid.new
        @robot = Robot.find message["robot_id"]
        if service.robot @robot
            reponse = {
                :message => 'bidok',
                :value => service.value,
                :units => service.units,
                :ench => service.nb_ench,
                :user_id => service.user.id,
                :units_robot => service.units_robot,
                :disable_robot_id => service.disable_robot_id
            }.to_json
            socket.send reponse
            notify_outbids socket, service.value , service.nb_ench, service.user.id , service.units_robot, service.disable_robot_id
        else
            if service.status == :won
                notify_auction_ended socket
            end
        end
    end

    def create_robot_socket message
        p message.to_s, "****************"
        socket = Faye::WebSocket.new env
        socket.send message
    end

    def notify_outbids socket, value , nb_ench, user_id ,units_robot, disable_robot_id
        reponse = {
            :message => 'outbid',
            :value  => value,
            :ench => nb_ench,
            :user_id => user_id,
            :units_robot => units_robot,
            :disable_robot_id => disable_robot_id
        }.to_json
        @clients.reject { |client| client == socket || !same_auction?(client,socket) }.each do |client|
            client.send reponse
        end
    end

    def notify_auction_ended socket
        socket.send "won"

        @clients.reject { |client| client == socket || !same_auction?(client,socket) }.each do |client|
            client.send "lost"
        end
    end

    def same_auction? other_socket, socket
        other_socket.env["REQUEST_PATH"] == socket.env["REQUEST_PATH"]
    end

    def chat socket, message
        notify_other socket, message
        # end
    end

    def notify_other socket , message

        @clients.reject { |client| client == socket  }.each do |client|
            reponse = {
                :action => 'chatnotifother',
                :message => message
            }.to_json
            client.send reponse
        end
    end

end
