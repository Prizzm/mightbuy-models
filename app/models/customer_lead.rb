class CustomerLead < ActiveRecord::Base
  belongs_to :business
  belongs_to :product

  validates :business, :email, presence: true
  image_accessor :photo
end
