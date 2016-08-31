require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
module RailsAdmin
  module Config
    module Actions
      class Charts < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :root? do
          true
        end
        register_instance_option :bulkable? do
          true
        end

        register_instance_option :visible? do
          true
        end
        register_instance_option :http_methods do
          [:get,:post]
        end
        register_instance_option :controller do
          proc do
            if request.get?
              #You can specify flash messages
              #flash.now[:danger] = "Some type of danger message here."

              #After you're done processing everything, render the new dashboard
              render @action.template_name, status: 200
            elsif request.post?
              case params[:stats]
                when 'total_value'
                  @stat = {:total_price => Product.total_price_online, :total_value => Auction.total_value_online}
                  respond_to do |format|
                    format.json { render @action.template_name}
                  end
                when 'cash_flow'
                  begins_at = params[:begins_at]
                  ends_at = params[:ends_at]
                  cash_flow = Order.cash_flow begins_at, ends_at
                  @stat = {:cash_flow => cash_flow[:range], :sum => cash_flow[:sum]}
                  respond_to do |format|
                    format.json { render @action.template_name}
                  end
                when 'used_coin'
                  begins_at = params[:begins_at]
                  ends_at = params[:ends_at]
                  used_coin = Bid.count_bid_by_date begins_at, ends_at
                  @stat = {:used_coin => used_coin}
                  respond_to do |format|
                    format.json { render @action.template_name}
                  end
                when 'used_coin_product'
                  @stat = {}
                  Auction.all.each do |auction|
                    @stat[auction.product.name] = @stat[auction.product.name].to_i + auction.bids.size
                  end
                  respond_to do |format|
                    format.json { render @action.template_name}
                  end
                else
                  @stat = nil
                  respond_to do |format|
                    format.json { render @action.template_name}
                  end
              end
            end

          end
        end

        register_instance_option :route_fragment do
          'charts'
        end

        register_instance_option :link_icon do
          'fa fa-line-chart'
        end

        register_instance_option :statistics? do
          true
        end
      end
    end
  end
end