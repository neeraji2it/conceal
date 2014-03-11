require 'csv'
require 'mailchimp'
class UsersController < ApplicationController
  autocomplete :city, :city, :full => true
  before_action :setup_mcapi, :only => ["create"]
  def autocomplete_city_city
    term = params[:term]
    if term && !term.empty?
      items = City.select("distinct city").
        where("LOWER(city) like ?", '%' + term.downcase + '%').order(:city)
    else
      items = {}
    end
    render :json => json_for_autocomplete(items, :city)
  end
  def new
    @user = User.new
    @high_cities = User.highest_rated
  end
  
  def create
    @user = User.new(user_params)
    @high_cities = User.highest_rated
    if @user.save
      unless Mailchimp::ListAlreadySubscribedError
        @mc.lists.subscribe(@list_id, {'email' => @user.email})
      end
      redirect_to new_user_payment_path(@user)
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
  
  def setup_mcapi
    @mc = Mailchimp::API.new(MAILCHIMP_API)
    @list_id = MAILCHIMP_LIST_ID
  end
  
  def change_top_value
    @high_cities = User.highest_rated
    city = params[:id]
    @user_city = User.select("users.city, AVG(users.fair_price) as avg_price, COUNT(users.id) as users_count").where(:city => city,:status => "Completed").group(:city)
    if @high_cities.present? and @user_city.present?
      @amount = @high_cities.last.avg_price - @user_city.last.avg_price + 1
    elsif @high_cities.present? and !@user_city.present?
      @amount = @high_cities.last.avg_price + 1
    else
      @amount = 51
    end
  end
  private
  def user_params
    params.require(:user).permit!
  end
end
