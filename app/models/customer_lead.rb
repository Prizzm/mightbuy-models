class CustomerLead < ActiveRecord::Base
  belongs_to :business
  belongs_to :product
  belongs_to :user

  has_many :customer_lead_topics
  has_many :topics, through: :customer_lead_topics

  accepts_nested_attributes_for :topics

  include MinistryOfState

  STATUSES = ["notsent", "sent", "accepted"]

  validates :business, :email, :status, presence: true
  validates :status, inclusion: { in: STATUSES }

  before_validation :rename_topics
  after_save :find_or_create_user
  after_save :associate_topics

  def rename_topics
    return if self.topics.length == 0

    self.topics.each do |topic|
      next if not topic.new_record?

      if self.product
        topic.subject = self.product.name
        topic.url     = self.product.url
      else
        topic.subject = self.business.business_urls.first.domain
      end
    end
  end

  def associate_topics
    return if self.topics.length == 0

    self.topics.each do |topic|
      topic.user = self.user
      topic.save
    end
  end


  def resize_image
    orientation =
      begin
        img = MiniMagick::Image.new(photo.path)
        img["EXIF:orientation"]
      rescue Exception => e
        p e
        1
      end

    case orientation.to_s
    when "8"; photo.process!(:rotate, -90).encode(:png)
    when "3"; photo.process!(:rotate, 180).encode(:png)
    when "6"; photo.process!(:rotate,  90).encode(:png)
    else;     photo.encode!(:png)
    end

    photo.process!(:resize, '1000x500>')
  end

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

  def create_invite
    LeadInvite.new(self)
  end

  def find_or_create_user
    self.user = self.user || User.find_by_email(user_params[:email])

    if not self.user
      self.user = User.create!(user_params)
      self.invite_token = SecureRandom.uuid
      self.save
    end

    self.user
  end


  private
  def user_params
    return @user_params if @user_params
    password = SecureRandom.hex(4)
    @user_params = {
      email: email,
      name: generated_username,
      password: password,
      password_confirmation: password
    }
  end

  def generated_username
    return name if name.present?

    email.gsub(/\@.+/,'')
  end
end
