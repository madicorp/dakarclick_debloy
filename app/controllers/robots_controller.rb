require "activate_robot"
class RobotsController < ApplicationController
  before_action :set_robot, only: [:show, :edit, :update, :destroy]

  # GET /robots
  # GET /robots.json
  def index
    @robots = Robot.all
  end

  # GET /robots/1
  # GET /robots/1.json
  def show
  end

  # GET /robots/new
  def new
    @robot = Robot.new
  end

  # GET /robots/1/edit
  def edit
  end

  # POST /robots
  # POST /robots.json
  def create
    @robot = Robot.new robot_params
    @robot.ends_at = Time.now + params[:robot][:ends_at].to_i
    @service = ActivateRobot.new
    if @service.create @robot
      #redirect_to auction_path(params[:auction_id]), notice: "Bid successfully placed."
    else
      #redirect_to auction_path(params[:auction_id]), alert: "Something went wrong."

    end
=begin
    @robots = Robot.new(robot_params)
    respond_to do |format|
      if @robots.save
        format.html { redirect_to @robots, notice: 'Robot was successfully created.' }
        format.json { render :show, status: :created, location: @robots }
      else
        format.html { render :new }
        format.json { render json: @robots.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # PATCH/PUT /robots/1
  # PATCH/PUT /robots/1.json
  def update
    @robot = Robot.new robot_params
    @robot.ends_at = Time.now + params[:robot][:ends_at].to_i
    @service = ActivateRobot.new
    if @service.create @robot
      #redirect_to auction_path(params[:auction_id]), notice: "Bid successfully placed."
    else
      redirect_to auction_path(params[:auction_id]), alert: "Something went wrong."
    end
  end

  # DELETE /robots/1
  # DELETE /robots/1.json
  def destroy
    @robot.destroy
    respond_to do |format|
      format.html { redirect_to robots_url, notice: 'Robot was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_robot
    @robot = Robot.find params[:id]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def robot_params
    params.require(:robot).permit(:ends_at, :units, :is_active, :user_id).merge!(
        auction_id: params[:auction_id])
  end
end
