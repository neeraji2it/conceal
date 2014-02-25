require 'csv'
class UsersController < ApplicationController
  autocomplete :city, :city, :scopes => [:uniquely_city], :full => true
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to new_user_order_path(@user)
    else
      render "new"
    end
  end
  
  def upload_cities
    if request.post? 
      if params[:cities]
        City.delete_all
        i = 0
        CSV.parse(params[:cities][:cities].read) do |row|
          # row = row[0].to_s.split("\t").collect(&:strip)
          puts row[5]
          puts i
          if (i != 0 and row[4] != " " and row[5] == " Illinois")
            City.create({
                :zipcode => row[0],
                :latitude => row[2],
                :longitude => row[3],
                :city => row[4],
                :state => row[5].strip,
                :state_abbr => row[1]
              }) 
          end
          i += 1
        end
        flash[:notice] = "Uploading completed."
        redirect_to root_path
      else
        redirect_to '/upload_cities'
      end
    else
      render :layout => false
    end
  end
  
  private
  def user_params
    params.require(:user).permit!
  end
end
