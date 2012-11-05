class CustomerLead < ActiveRecord::Base
  belongs_to :business
  belongs_to :product

  validates :business, :email, presence: true
  image_accessor :photo

  def send_notifications
    LeadsMailer.invite_customer(self).deliver
  end
end
