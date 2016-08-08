class PlaceBid
    attr_reader :auction, :status, :user, :value , :units, :auction_close , :nb_ench , :productid, :units_robot, :disable_robot_id, :robot_id, :winner
    def execute options
        @user_id = options[:user_id].to_i
        @auction_id = options[:auction_id].to_i

        @auction = Auction.find @auction_id
        @user = User.find @user_id

        if auction.ended? && auction.top_bid.user_id == @user_id
            @status = :won
            return false
        end

        if user.units >= 2
            auction.value += auction.valuetoinc
            puts "#{auction.auction_close - Time.now}"
            if (auction.auction_close - Time.now)< 60
              auction.auction_close += 30.seconds
            end
            user.units -= 2
            @value = auction.value
            @units = user.units
            @auction_close = auction.auction_close.to_formatted_s(:db)

            ActiveRecord::Base.transaction do
                auction.save
                user.save
            end
            @nb_ench = auction.bids.size + 1
            #
            # else
            #     @value = auction.value
            #     return false
        end

        bid = auction.bids.build value: @value, user_id: @user_id

        if bid.save
            return true
        else
            return false
        end
    end
    def robot robot
        @auction = robot.auction
        if robot.units >= 2 && robot.ends_at > Time.now
            if !auction.ended? && auction.top_bid.user_id == robot.user_id
                @user = robot.user
                @status = :won
                return true
            end
            @winner = robot.user_id
            if @auction.active_robots.size > 1

                @robots = @auction.active_robots
                r1 = @robots.first
                u_r1 = r1.units
                r2 = @robots.last
                u_r2 = r2.units
                if u_r1 % 2 != 0
                    u_r1-=1
                end
                if u_r2 % 2 != 0
                    u_r2-=1
                end
                if u_r1 > u_r2
                    times = u_r2/2
                    u_r1= r1.units - u_r2
                    u_r2=r2.units - u_r2
                    auction.value += auction.valuetoinc * times
                    auction.auction_close += auction.timetoinc.seconds * times
                    r2.is_active = false
                    r2.ends_at = nil
                    @disable_robot_id = r2.id
                    @winner = r1.user_id
                elsif u_r1 < u_r2
                    times = u_r1/2
                    u_r2= r2.units - u_r1
                    u_r1= r1.units - u_r1
                    auction.value += auction.valuetoinc * times
                    auction.auction_close += auction.timetoinc.seconds * times
                    r1.is_active = false
                    r1.ends_at = nil
                    @disable_robot_id = r1.id
                    @winner = r2.user_id
                elsif u_r2 == u_r1
                    times = u_r2/2
                    auction.value += auction.valuetoinc * times
                    auction.auction_close += auction.timetoinc.seconds * times
                    u_r2= r2.units - u_r2
                    u_r1= r1.units - u_r1
                  if u_r1 > u_r2
                      @winner = r1.user_id
                      r2.is_active = false
                      r2.ends_at = nil
                      @disable_robot_id = r2.id
                  elsif u_r1 < u_r2
                      @winner = r2.user_id
                      r1.is_active = false
                      r1.ends_at = nil
                      @disable_robot_id = r1.id
                  elsif u_r1 == u_r2
                    case @winner
                        when r1.user_id
                            r2.is_active = false
                            r2.ends_at = nil
                            @disable_robot_id = r2.id
                        when r2.user_id
                            r1.is_active = false
                            r1.ends_at = nil
                            @disable_robot_id = r1.id
                    end
                  end
                end
                @value = auction.value
                r1.units = u_r1
                r2.units = u_r2
                ActiveRecord::Base.transaction do
                    r1.save
                    r2.save
                end
                robot = Robot.find robot.id
            else
                auction.value += auction.valuetoinc
                auction.auction_close += auction.timetoinc.seconds
                robot.units -= 2
                if  robot.units < 2
                    robot.is_active = false
                    robot.ends_at = nil
                    @disable_robot_id =  robot.id
                end
                ActiveRecord::Base.transaction do
                    auction.save
                    robot.save
                end
            end
        else
            robot.is_active = false
            robot.ends_at = nil
            robot.save
        end

        @value = auction.value
        @auction_close = auction.auction_close
        @user = robot.user
        @units = user.units
        @units_robot = robot.units

        @nb_ench = auction.bids.size + 1

        @robot_id = robot.id

        p  @winner, "!!!!!!!!!!!!!!!!!!!!!!!"

        bid = auction.bids.build value: @value, user_id: @winner

        if bid.save
            return true
        else
            return false
        end
    end
end
