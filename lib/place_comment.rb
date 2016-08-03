class PlaceComment
    attr_reader :user_id, :message
    def execute options
        @user_id = options[:user_id].to_i
        @message = options[:message]
        @user = User.find @user_id

          @comment = Comment.new
          @comment.user = @user
          @comment.body = @message

        if @comment.save
            return true
        end

      return false
    end
 end
