class Bargin < ActiveRecord::Base
  belongs_to :product
  has_many :anti_forge_tokens
  has_many :bargin_conditions

  attr_accessible :name,
                  :offer,
                  :type,
                  :description,
                  :url,
                  :value,
                  :bargin_type,
                  :barcode,
                  :type,
                  :accept_payments,
                  :payment_type,
                  :discount

  attr_accessible :bargin_conditions_attributes

  validates :product, presence: true


  accepts_nested_attributes_for :bargin_conditions
end
