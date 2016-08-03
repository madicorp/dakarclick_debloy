module CommentsHelper
    def profile_avatar(user)
        gravatar_image_url(user.email.to_s.gsub('spam', 'mdeering'), filetype: :png, size: 60, secure:false, default: :monsterid)
    end

    def load_class(user)
        if !current_user.nil? && user.id == current_user.id
            "right"
        else
            "left"
        end
    end

end
