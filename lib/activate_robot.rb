require File.expand_path "../place_bid", __FILE__
require File.expand_path "../auction_socket", __FILE__

class ActivateRobot
  attr_reader :auction, :is_active, :user, :ends_at , :units, :id, :reponse
  def create options
    #init components
    @user_id = options[:user_id].to_i
    @auction_id = options[:auction_id].to_i
    @ends_at = options[:ends_at]
    @units = options[:units].to_i
    @is_active = options[:is_active]
    @id =  (options[:user_id].to_s + options[:auction_id].to_s).to_i


    @auction = Auction.find @auction_id
    @user = User.find @user_id
    @robot = Robot.find_by_id @id
    if @robot.nil?
      @robot = Robot.new
      @robot.is_active = true
    else
      if @ends_at < Time.now || !@is_active
        @robot.is_active = false
        @robot.ends_at = nil
      else
        @robot.is_active = true
      end
    end
    if @user.units >= @units && !@auction.ended? && @robot.is_active && @units > 2
      @robot.id = (@user.id.to_s + @auction.id.to_s).to_i
      @robot.user = @user
      @robot.auction = @auction

      @robot.units = @units
      user.units -= @units
      @robot.ends_at = @ends_at

      @value = @auction.value
      @units = user.units
      @auction_close = auction.auction_close

      ActiveRecord::Base.transaction do
        auction.save
        user.save
      end
      if @robot.save
        if @user_id != @auction.top_bid.user_id
          service = PlaceBid.new
          service.robot @robot

          @reponse = {
              :message => 'createrobotok',
              :value => service.value,
              :units => service.units,
              :ench => service.nb_ench,
              :user_id => @auction.top_bid.user_id,
              :auction_id => @auction.id,
              :units_robot => service.units_robot,
              :disable_robot_id => service.disable_robot_id,
              :robot_ends_at => @robot.ends_at.to_formatted_s(:db)
          }.to_json
        else
          @reponse = {
              :message => 'createrobotok',
              :value => @auction.value,
              :units => @user.units,
              :ench => @auction.bids.size,
              :user_id => @auction.top_bid.user_id,
              :auction_id => @auction.id,
              :units_robot => @robot.units,
              :robot_ends_at => @robot.ends_at.to_formatted_s(:db)
          }.to_json
        end
        return true
      else
        return false
      end
    else
      @robot.save
      dis_robot = nil
      unless @robot.is_active
        dis_robot = @robot.id
      end
      end_robot = @robot.ends_at.to_formatted_s(:db) unless @robot.ends_at.nil?
      @reponse = {
          :message => 'createrobotok',
          :value => @auction.value,
          :units => @user.units,
          :ench => @auction.bids.size,
          :user_id => @auction.top_bid.user_id,
          :auction_id => @auction.id,
          :units_robot => @robot.units,
          :disable_robot_id => dis_robot,
          :robot_ends_at => end_robot
      }.to_json
      return true
    end
  end

end