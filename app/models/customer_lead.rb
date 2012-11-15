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

  def normalized_photo
    orientation =
      begin
        img = MiniMagick::Image.new(photo.path)
        img["EXIF:orientation"]
      rescue Exception => e
        p e
        1
      end

    case orientation.to_s
    when "8"; photo.process(:rotate, -90).encode(:png)
    when "3"; photo.process(:rotate, 180).encode(:png)
    when "6"; photo.process(:rotate,  90).encode(:png)
    else;     photo.encode(:png)
    end
  end

  # http://railscasts.com/episodes/362-exporting-csv-and-excel
  # first add column headers
  # then for each lead, extract those values.
  def self.to_csv
    CSV.generate do |csv|
      csv << ["Id", "Registered On", "Name", "Email", "Product", "Status"]
      all.each do |lead|
        csv << [ lead.id, lead.created_at, lead.name, lead.email,
                 lead.product.try(:name), lead.humanized_status ]
      end
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
      email: email, name: generated_username,
      password: password, password_confirmation: password
    }
  end

  def generated_username
    return name if name.present?

    email.gsub(/\@.+/,'')
  end

  def topic_params
    {
      subject: product.name, url: product.url,
      image_uid: photo_uid, access: 'public'
    }
  end
end
