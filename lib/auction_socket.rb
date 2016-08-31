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
                end

                if message["message"] == "createrobotok"
                    message["message"] = "bidok"
                    socket.send message
                    notify_outbids socket,  message["value"] ,   message["ench"],   message["user_id"] , message["units_robot"] ,message["disable_robot_id"],nil,nil,nil
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
                :value => ActiveSupport::NumberHelper.number_to_currency(service.value, precision: 0, unit: 'FCFA'),
                :units => service.units,
                :ench => service.nb_ench,
                :user_id => service.user.id,
                :units_robot => service.units_robot,
                :auction_id => service.auction.id,
                :last_users => service.auction.podium,
                :auction_close => service.auction_close
            }.to_json
            socket.send reponse
            notify_outbids socket, service.value , service.nb_ench, service.user.id , -1,nil,service.auction.id ,service.auction.podium,service.auction_close
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
                :value => ActiveSupport::NumberHelper.number_to_currency(service.value, precision: 0, unit: 'FCFA'),
                :units => service.units,
                :ench => service.nb_ench,
                :user_id => service.user.id,
                :units_robot => service.units_robot,
                :disable_robot_id => service.disable_robot_id,
                :last_users => service.auction.podium

            }.to_json
            socket.send reponse
            notify_outbids socket, service.value , service.nb_ench, service.user.id , service.units_robot, service.disable_robot_id,service.auction.id , service.auction.podium ,nil
        else
            if service.status == :won
                notify_auction_ended socket
            end
        end
    end

    def create_robot_socket message
        socket = Faye::WebSocket.new env
        socket.send message
    end

    def notify_outbids socket, value , nb_ench, user_id ,units_robot, disable_robot_id ,auction_id , last_users ,auction_close
        reponse = {
            :message => 'outbid',
            :value  => ActiveSupport::NumberHelper.number_to_currency(value, precision: 0, unit: 'FCFA'),
            :ench => nb_ench,
            :user_id => user_id,
            :auction_id => auction_id,
            :units_robot => units_robot,
            :disable_robot_id => disable_robot_id,
            :last_users => last_users,
            :auction_close => auction_close
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
