class CustomerLead < ActiveRecord::Base
  belongs_to :business
  belongs_to :product

  STATUSES = ["notsent", "sent", "accepted"]

  validates :business, :email, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
  image_accessor :photo


  def humanized_status
    case status
    when "notsent";  'Not Sent'
    when "sent";     'Sent'
    when "accepted"; 'Accepted'
    else status
    end
  end

  def create_topic_customer
    lead_invite = LeadInvite.new(self)
    transaction do
      user = create_user
      topic = Topic.new(topic_params)
      topic.user = user
      topic.save!
      lead_invite.add(topic: topic, user: user)
    end
  rescue StandardError => e
    lead_invite.add_error(e.message)
  end

  def create_user
    user = User.find_by_email(user_params[:email])
    if user
      user.update_attributes!(invite_token: nil)
      user
    else
      User.create!(user_params)
    end
  end

  private
  def user_params
    return @user_params if @user_params
    password = SecureRandom.hex(4)
    @user_params = {
      email: email, name: name,
      password: password, password_confirmation: password,
      invite_token: SecureRandom.uuid
    }
  end

  def topic_params
    {
      subject: product.name, url: url,
      image_uid: photo_uid, access: 'public'
    }
  end
end
