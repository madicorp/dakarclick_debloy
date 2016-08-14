class CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    @comment = Comment.new
    @comments = Comment.order('created_at DESC').limit(7)
    @comments = @comments.sort_by { |c| c[:created_at]}
  end
  def create
    respond_to do |format|
      if current_user
        @comment = current_user.comments.build(comment_params)
        if @comment.save
          @comments = Comment.order('created_at DESC').limit(7)
          @comments = @comments.sort_by { |c| c[:created_at]}
          format.js { render  content_type: 'text/javascript' }
        end
      else
        format.js {render nothing: true}
      end
    end
  end
  def refresh
    respond_to do |format|
      @comments = Comment.order('created_at DESC').limit(7)
      @comments = @comments.sort_by { |c| c[:created_at]}
      format.js { render "comments/create",  content_type: 'text/javascript' }
    end
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
