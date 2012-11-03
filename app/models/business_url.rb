class BusinessUrl < ActiveRecord::Base
  attr_accessor :domain

  belongs_to :business
end
