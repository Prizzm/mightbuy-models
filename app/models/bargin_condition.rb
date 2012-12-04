class BarginCondition < ActiveRecord::Base
  belongs_to :bargin

  OBJECTS = [
    "Comment",
    "Vote"
  ]

  OPERATORS = {
    '>' => 'more than',
    '<' => 'less than',
    '>=' => 'more than or equal to',
    '<=' => 'less than or equal to',
    '==' => 'is equal to',
    '!=' => 'is not equal to'
  }

  attr_accessible :object,
                  :operator,
                  :operand

  validates :object, presence: true, inclusion: { in: OBJECTS }
  validates :operator, presence: true, inclusion: { in: OPERATORS }
end
