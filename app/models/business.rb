class Business < ActiveRecord::Base
  has_many :products

  has_many :business_staffs

  image_accessor :logo

  def foreground_color
    self.foreground.split(',')
  end
  
  def background_color
    self.background.split(',')
  end
end
