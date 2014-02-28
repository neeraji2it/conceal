class PaymentsController < ApplicationController
  def new
    @user = User.find(params[:user_id])
    @payment = Payment.new
  end
  
  def create
    @user = User.find(params[:user_id])
    @payment = Payment.new(params_payment.merge(:user_id => @user.id))
    if @payment.save && @payment.purchase
      @payment.user.update_attribute(:status, "Completed")
      redirect_to "/"
    else
      render :action => "new"
    end
  end
  
  private
  def params_payment
    params.require(:payment).permit!
  end
end
