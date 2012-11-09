class CustomerLead < ActiveRecord::Base
  belongs_to :business
  belongs_to :product
  belongs_to :user

  include MinistryOfState

  STATUSES = ["notsent", "sent", "accepted"]

  validates :business, :email, :status, presence: true
  validates :status, inclusion: { in: STATUSES }
  image_accessor :photo

  ministry_of_state("status") do
    add_initial_state :notsent
    add_state :sent
    add_state :accepted

    add_event(:send_invite) do
      transitions from: :notsent, to: :sent
    end

    add_event(:accept) do
      transitions from: :sent, to: :accepted
    end
  end

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
      lead_user = find_or_create_user()
      topic = Topic.new(topic_params)
      topic.user = lead_user
      topic.save!
      lead_invite.add(topic: topic, user: user)
    end
  rescue StandardError => e
    lead_invite.add_error(e.message)
  end

  def find_or_create_user
    old_user = self.user || User.find_by_email(user_params[:email])
    return old_user if old_user
    user = User.create!(user_params)
    update_attributes!(user_id: user.id, invite_token: SecureRandom.uuid)
    user
  end

  private
  def user_params
    return @user_params if @user_params
    password = SecureRandom.hex(4)
    @user_params = {
      email: email, name: name,
      password: password, password_confirmation: password
    }
  end

  def topic_params
    {
      subject: product.name, url: product.url,
      image_uid: photo_uid, access: 'public'
    }
  end
end
