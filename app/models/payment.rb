class Payment < ActiveRecord::Base
  belongs_to :user
  serialize :params
  
  attr_accessor :card_number, :card_verification
  
  validate :validate_card, :on => :create
  
  def purchase
    options = {:profile => {
        :merchant_customer_id => self.user.id.to_s,
        :email => self.user.email.to_s
      }
    }
    customer_profile = GATEWAY.create_customer_profile(options)
    customer_profile_id = customer_profile.params["customer_profile_id"]
    payment_profile = {
      :bill_to => {
        :first_name   => first_name, 
        :last_name    => last_name, 
        :address      => address, 
        :state        => state, 
        :country      => country, 
        :zip          => zip,
        :phone_number => phone_number, 
        :fax_number   => fax_number
      },
      :payment => {
        :credit_card => credit_card
      }
    }
    options = {
      :customer_profile_id => customer_profile_id,
      :payment_profile => payment_profile
    }
    payment_profile = GATEWAY.create_customer_payment_profile(options)
    customer_payment_profile_id = payment_profile.params["customer_payment_profile_id"]
    transaction = 
      {:transaction => {
        :type => :auth_capture, 
        :amount => price_in_cents, 
        :customer_profile_id => customer_profile_id, 
        :customer_payment_profile_id => customer_payment_profile_id
      }
    }
    response = GATEWAY.create_customer_profile_transaction(transaction)
    self.update_attributes(:action => "auth_capture", :amount => price_in_cents, :success => response.success?, :authorization => response.authorization, :message => response.message, :params => response.params, :customer_profile_id => customer_profile_id, :customer_payment_profile_id => customer_payment_profile_id)
    response.success?
  end
  
  def price_in_cents
    ((self.user.fair_price.to_f + self.user.one_time_donation.to_f)).round
  end
  
  private
  
  def validate_card
    if !credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add(:base, message)
      end
    end
  end
  
  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :brand => card_type,
      :number => card_number,
      :verification_value => card_verification,
      :month => card_expires_on.month,
      :year => card_expires_on.year,
      :first_name => first_name,
      :last_name => last_name
    )
  end
end
