class CustomerLead < ActiveRecord::Base
  belongs_to :business
  belongs_to :product

  STATUSES = ["Not Sent", "Sent", "Accepted"]

  validates :business, :email, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
  image_accessor :photo

  def send_notifications
    LeadsMailer.invite_customer(self).deliver
  end
end
