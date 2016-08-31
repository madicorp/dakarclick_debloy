RailsAdmin.config do |config|
  require Rails.root.join('lib','rails_admin', 'rails_admin_charts.rb')
  ### Popular gems integration
    # config.main_app_name = Proc.new { |controller| [  "DakarClic - #{controller.params[:action].try(:titleize)}" ] }

  # == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :admin
  # end
  # config.current_user_method(&:current_admin)

  ## == Cancan ==
  # config.authorize_with :cancan, AdminAbility
    config.authorize_with do
         redirect_to main_app.new_user_session_path unless current_user && current_user.admin
    end
  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    charts                        #custom
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete

    ## With an audit adapter, you can add:
     history_index
     history_show
  end

    if defined?(WillPaginate)
        module WillPaginate
            module ActiveRecord
                module RelationMethods
                    alias_method :per, :per_page
                    alias_method :num_pages, :total_pages
                    alias_method :total_count, :count
                end
            end
        end
    end
end
