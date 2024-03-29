class Topic < ActiveRecord::Base
  has_many :customer_lead_topics
  has_one :customer_lead, through: :customer_lead_topics

  # Includes
  include InheritUpload
  include ActionView::Helpers::NumberHelper
  include Topic::SocialIntegration
  include Topic::FormEndPoints
  include Topic::Have
  include Topic::Trends
  # Options
  Access = {
    "Anyone." => "public",
    "Only by Invite." => "private"
  }

  STATUSES = ["imightbuy", "ihave"]
  RECOMMENDATIONS = ["undecided", "recommended", "not-recommended"]

  # Relationships
  has_many :responses
  has_many :shares, :class_name => "Shares::Share", :inverse_of => :topic
  has_many :email_shares, :class_name => "Shares::Email", :inverse_of => :topic
  belongs_to :user
  belongs_to :product
  has_many :orders

  has_many :topic_tags
  has_many :tags, through: :topic_tags
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  has_many :commenters, through: :comments, source: :user, uniq: true do
    def exclude(commenter)
      where("comments.user_id != ?", commenter.id)
    end
  end

  # Scopes
  scope :publics, where(:access => "public")
  scope :privates, where(:access => "private")
  scope :have, where(status: "ihave")
  scope :mightbuy, where(status: "imightbuy")

  # Validations
  validates :access, :presence => { :message => "Please select one of the above" }
  validates :shortcode, :presence => true, :uniqueness => true
  validates :subject, :presence => true
  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :recommendation, presence: true, inclusion: { in: RECOMMENDATIONS }

  # Uploaders
  image_accessor :image

  # Nested Attributes
  accepts_nested_attributes_for :shares, :reject_if => proc { |attributes| attributes["with"].blank? }
  accepts_nested_attributes_for :email_shares, :reject_if => proc { |attributes| attributes["with"].blank? }

  # Attributes
  attr_accessor :pass_visitor_code

  # Methods
  after_create :find_product

  has_many :timeline_events, :as => :subject, :dependent => :destroy

  fires 'new_topic', on: :create, actor: :user
  fires 'modified_topic', on: :update, actor: :user

  def self.find_by_shortcode(shortcode)
    super(shortcode && shortcode.split("-")[0])
  end

  def self.latest_posts(page_number = 1)
    self.order("created_at desc").page(page_number).per(10)
  end

  def add_tags(tag_array)
    !tag_array.blank? && tag_array.each do |tag_name|
      if persisted? && tags.find_by_name(tag_name)
        next
      else
        self.tags << Tag.find_or_initialize_by_name(tag_name)
      end
    end
  end

  def update_tags(tag_array)
    incoming_tags = tag_array.map {|tag_name| Tag.find_or_create_by_name(tag_name) }
    self.tags = incoming_tags
    self
  end

  def poster_name(current_user = nil)
    if current_user && user == current_user
      "You"
    else
      user ? user.name : "anonymous"
    end
  end

  def tag_array
    self.tags ? self.tags.map(&:name) : []
  end

  def vote_statistics
    return @vote_statistics if @vote_statistics

    if votes.empty?
      @vote_statistics = {
        percentage: {
          yes: 0,
          no: 0,
          total: 0
        },
        number: {
          yes: 0,
          no: 0,
          total: 0
        }
      }
    else
      vote_count = votes.inject(yes: 0, no: 0) do |mem, vote|
        vote.buyit ? mem[:yes] += 1 : mem[:no] += 1
        mem
      end
      total_votes = votes.count

      @vote_percentage = {
        percentage: {
          yes: (vote_count[:yes] * 100) / total_votes,
          no: (vote_count[:no] * 100) / total_votes,
          total: 100
        },
        number: {
          yes: vote_count[:yes],
          no: vote_count[:no],
          total: total_votes
        }
      }
    end
  end

  def short_url
    url ? url.first(40) + "..." : ""
  end

  def has_bargin?
    product && product.bargin
  end

  def bargin_valid?
    return unless has_bargin?

    product    = self.product
    conditions = self.product.bargin.bargin_conditions

    correct = 0
    conditions.each do |condition|
      case condition.object
      when 'Comment'
        if comments.length.send(condition.operator, condition.operand)
          correct = correct + 1
        end
      when 'Vote'
        if votes.length.send(condition.operator, condition.operand)
          correct = correct + 1
        end
      end
    end

    correct.eql?(conditions.length)
  end

  def find_product
    p = Product.find_by_url(url)
    if p then
      t = self
      t.product = p
      t.save
    else
      t = self
      pn = Product.new()

      pn.name = t.subject
      pn.url = t.url
      pn.save

      t.product = pn
      t.save
    end
  end


  def displayPrice
    if self.price
      return " #{number_to_currency(self.price)}."
    else
      return ""
    end
  end

  def owner?(p_user)
    user == p_user
  end

  def thumbnail_image
    if image
      image.thumb("187x137#").url
    else
      "/assets/no_image.png"
    end
  end

  def icon_image
    if image
      image.thumb("64x64#").url
    else
      "/assets/no_image.png"
    end
  end

  def copy(another_user)
    another_topic = Topic.new()
    another_topic.attributes = self.attributes.except('shortcode', 'id', 'type', 'created_at', 'updated_at')
    another_topic.tags = self.tags
    another_topic.status = 'imightbuy'
    another_topic.user = another_user
    another_topic
  end

  def iImage(host = true)
    if host == true
      # Check env
      if Rails.env.production?
        if self.image
          # Return image.url with host
          # https://www.mightbuy.it/topics/43P16H (mightbuy.it)
          return self.image.url(:host => "https://www.mightbuy.it")
        else
          return "https://www.mightbuy.it/assets/no_image.png"
        end
      else
        if self.image
          return self.image.url(:host => MB.config.app_url)
        else
          return "https://www.mightbuy.it/assets/no_image.png"
        end
      end
    else #host is not true - handle blank and
      # Other image.url without host (Path Only)
      # /topics/43P16H
      if self.image then
        self.image.url
      else
        "https://www.mightbuy.it/assets/no_image.png"
      end
    end
  end

  def update_topic_with_image(params)
    if params[:image_url] && URI.parse(URI.encode(params[:image_url])).host
      params[:image_url] = URI.parse(URI.encode(params[:image_url])).to_s
    else
      params.delete(:image_url)
    end
    update_attributes!(params)
  end

  def url
    url = attributes['url']
    url.blank? ? url : Scrape.full_url(url)
  end

  def post?
    !question?
  end

  def question?
    subject[/\?\s*$/i] ? true : false
  end

  def form?
    form.to_s.to_sym
  end

  def to_param
    shortcode + "-" + "#{subject}".parameterize
  end

  def share_csv= (file)
    Importer.csv(file, self)
  end

  def stats
    @stats ||= Statistics.for(self)
  end

  def recommended?
    recommendation == "recommended"
  end

  def not_recommended?
    recommendation == "not-recommended"
  end

  def recommended_by?(user)
    !!shares.recommends.find_by_user_id(user.id)
  end

  def activity_line(timeline_event)
    actor = timeline_event.actor
    if timeline_event.event_type == 'modified_topic'
      "#{actor.name} updated <a href='/topics/#{to_param}'>#{subject.first(45)}..</a> in their mightbuy list".html_safe
    else
      "#{actor.name} added <a href='/topics/#{to_param}'>#{subject.first(45)}..</a> to their mightbuy list".html_safe
    end
  end

  def vote(user, buyit)
    vote = user ? votes.find_by_user_id(user.id) : nil
    vote ||= votes.build(user: user)

    vote.buyit = buyit
    vote.save
    vote
  end

  def vote_by(voter)
    if voter
      votes.find_by_user_id(voter.id)
    else
      nil
    end
  end

  def business
    direct_business = product.try(:business)
    return direct_business if direct_business

    business_url = BusinessUrl.where(fqdn: product.domain_name).first
    business_url.try(:business)
  end

  def ordered_comments
    comments.joins(:user).
      where(parent_id: nil).order("comments.created_at ASC").
      includes(:user)
  end

  def normalized_photo
    orientation =
      begin
        img = MiniMagick::Image.new(image.path)
        img["EXIF:orientation"]
      rescue Exception => e
        p e
        1
      end

    case orientation.to_s
    when "8"; image.process(:rotate, -90).encode(:png)
    when "3"; image.process(:rotate, 180).encode(:png)
    when "6"; image.process(:rotate,  90).encode(:png)
    else;     image.encode(:png)
    end
  end

end
