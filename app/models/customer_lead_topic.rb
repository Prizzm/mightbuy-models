class CustomerLeadTopic < ActiveRecord::Base
  belongs_to :customer_lead
  belongs_to :topic
end
