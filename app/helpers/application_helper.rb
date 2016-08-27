module ApplicationHelper
    def resource_name
        :user
    end

    def resource
        @resource ||= User.new
    end

    def devise_mapping
        @devise_mapping ||= Devise.mappings[:user]
    end

    def flash_class(level)
        case level
            when :notice then "notice"
            when :info then "info"
            when :error then "error"
            when :alert then "alert"
            else "info"
        end
    end
end
