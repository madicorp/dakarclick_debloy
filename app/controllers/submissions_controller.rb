class SubmissionsController < ApplicationController
  def index
      @submission = Submission.new
  end

  def create
      @submission = Submission.new(submission_params)
      if @submission.save
          flash[:success] = "The submission was added!"
          render 'submissions/create'
      else
          render 'submissions/index'
      end
  end

  private

  def submission_params
      params.require(:submission).permit(:image, :description , :contact).merge!(
          user_id: current_user.id
      )
  end
end
