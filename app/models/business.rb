class Business < ActiveRecord::Base
  has_many :products

  has_one  :business_config
  has_many :business_staffs
  has_many :business_urls
  has_many :customer_leads

  image_accessor :logo

  accepts_nested_attributes_for :business_urls, :reject_if => proc { |attributes| attributes['domain'].blank? }
  after_create   :create_business_config

  def timeline_events
    # Get all product ids
    products = self.products.map(&:id)
    topics = Topic.find(:all, conditions: {
      product_id: products
    }).map(&:id)

    primary_events = TimelineEvent.find(:all, conditions: {
      subject_type: 'Topic',
      subject_id: topics
    }, order: 'updated_at DESC')

    secondary_events = TimelineEvent.find(:all, conditions: {
      secondary_subject_type: 'Topic',
      secondary_subject_id: topics
    }, order: 'updated_at DESC')

    return primary_events.concat(secondary_events)
  end

  def foreground_color
    self.foreground.split(',')
  end

  def background_color
    self.background.split(',')
  end

  def products_via_urls
    business_urls.flat_map do |business_url|
      Product.where(domain_name: business_url.fqdn)
    end
  end

  def all_products
    Set.new(products.to_a + products_via_urls)
  end

  def find_and_update_product(product_id)
    product = all_products.detect { |product| product.id == product_id.to_i }
    return nil unless product

    return product if product && product.business
    product.update_column('business_id',self.id)
    product
  end

  def customers
    business_customers = Set.new()
    all_products.each do |product|
      business_customers += User.joins(:topics).where("topics.product_id = ?",product.id).all
    end
    business_customers
  end
end

