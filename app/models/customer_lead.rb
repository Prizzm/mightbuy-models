class CustomerLead < ActiveRecord::Base
  belongs_to :business
  belongs_to :product

  STATUSES = ["notsent", "sent", "accepted"]

  validates :business, :email, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
  image_accessor :photo

  before_validation  :normailze_status

  def send_notifications
    LeadsMailer.invite_customer(self).deliver
  end

  def humanized_status
    case status
    when "notsent";  'Not Sent'
    when "sent";     'Sent'
    when "accepted"; 'Accepted'
    else status
    end
  end

  def normailze_status
    db_status =
      case self.status
      when 'Not Sent';  "notsent"
      when 'Sent';      "sent"
      when 'Accepted';  "accepted"
      else self.status
      end

    self.status = db_status
  end
end
