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

  end
end
