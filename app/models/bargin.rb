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
                  :discount,
                  :public

  attr_accessible :bargin_conditions_attributes

  validates :product, presence: true


  accepts_nested_attributes_for :bargin_conditions


  def humanize
    conditions = self.bargin_conditions.where('operand != ?', 0)

    if conditions.length.eql?(0)
      return
    end


    string = ''
    conditions.each do |condition|
      next if condition.operand.eql?(0)

      string += BarginCondition::OPERATORS[condition.operator]
      string += " #{condition.operand} of your friends #{condition.object.downcase} and"
    end

    string.gsub(/ and$/, '')
  end
end
