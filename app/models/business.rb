class Business < ActiveRecord::Base
  has_many :products

  has_many :business_staffs
  has_many :business_urls

  image_accessor :logo

  accepts_nested_attributes_for :business_urls, :reject_if => proc { |attributes| attributes['domain'].blank? }

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

  def customers
    business_customers = Set.new()
    all_products.each do |product|
      business_customers += User.joins(:topics).where("topics.product_id = ?",product.id).all
    end
    business_customers
  end
end

