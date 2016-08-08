class CommentsController < ApplicationController
    skip_before_action :verify_authenticity_token

    def index
        @comment = Comment.new
        @comments = Comment.order('created_at ASC').limit(10)
    end

  def create
      respond_to do |format|
          if current_user
              @comment = current_user.comments.build(comment_params)
              @comments = Comment.order('created_at ASC').limit(10)
              if @comment.save
                  flash.now[:success] = 'Your comment was successfully posted!'
              else
                  flash.now[:error] = 'Your comment cannot be saved.'
              end
              format.js { render  content_type: 'text/javascript' }
          else
              format.js {render nothing: true}
          end
      end
  end
    def refresh
        respond_to do |format|
            @comments = Comment.order('created_at ASC').limit(10)
            format.js { render "comments/create",  content_type: 'text/javascript' }
        end
    end

    def comment_params
        params.require(:comment).permit(:body)
    end
end
