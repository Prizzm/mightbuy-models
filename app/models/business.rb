class Business < ActiveRecord::Base
  has_many :products

  has_many :business_staffs

  # has_many :business_products
  # has_many :products, :through => :business_products
  
  def foreground_color
    self.foreground.split(',')
  end
  
  def background_color
    self.background.split(',')
  end
end
