class SubmissionsController < ApplicationController
  def index
      @submission = Submission.new
  end

  def create
    redirect_to root_path if current_user.nil?
      @submission = Submission.new(submission_params)
      if @submission.save
          flash[:success] = "Merci pour votre proposition, nous en tiendrons compte ! :)"
      else
          flash[:success] = "Une erreur s'est produite veuillez réessayer ultérieurement ."
      end
      redirect_to root_path
  end

  private

  def submission_params
      params.require(:submission).permit(:image, :description , :contact).merge!(
          user_id: current_user.id
      )
  end
end
