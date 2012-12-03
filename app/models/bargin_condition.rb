class BarginCondition < ActiveRecord::Base
  belongs_to :bargin

  OBJECTS = [
    "Comment",
    "Vote"
  ]

  OPERATORS = [
    '>',
    '<',
    '>=',
    '<=',
    '=',
    '!='
  ]

  attr_accessible :object,
                  :operator,
                  :operand

  validates :object, presence: true, inclusion: { in: OBJECTS }
  validates :operator, presence: true, inclusion: { in: OPERATORS }
end
