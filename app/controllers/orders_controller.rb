class OrdersController < ApplicationController
  def express
    @user = User.find(params[:id])
    price = @user.fair_price.to_f + @user.one_time_donation.to_f
    response = EXPRESS_GATEWAY.setup_purchase( price,
      :ip => request.remote_ip,
      :return_url => new_user_order_url(@user),
      :cancel_return_url => users_url,
      :description => "Fair Price: #{price}"
    )
    redirect_to EXPRESS_GATEWAY.redirect_url_for(response.token)
  end
  
  def new
    @user = User.find(params[:user_id])
    @order = Order.new(:express_token => params[:token])
  end
  
  def create
    @user = User.find(params[:user_id])
    @order = Order.new(params_order.merge(:user_id => @user.id, :ip_address => request.remote_ip, :payment_type => "Paypal"))
    if @order.save && @order.purchase
      @order.user.update_attribute(:status, "Completed")
      redirect_to '/'
    else
      render :action => "new"
    end
  end
  
  private
  def params_order
    params.require(:order).permit!
  end
end
