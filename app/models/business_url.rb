class BusinessUrl < ActiveRecord::Base
  attr_accessible :domain, :business

  belongs_to :business

  validates_presence_of :domain
end
