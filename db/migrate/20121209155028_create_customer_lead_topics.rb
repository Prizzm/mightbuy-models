class CreateCustomerLeadTopics < ActiveRecord::Migration
  def change
    create_table :customer_lead_topics do |t|
      t.references :customer_lead
      t.references :topic
    end
    add_index :customer_lead_topics, :customer_lead_id
    add_index :customer_lead_topics, :topic_id
  end
end
