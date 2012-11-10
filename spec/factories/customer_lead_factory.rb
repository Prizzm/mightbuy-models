FactoryGirl.define do
  sequence(:lead_email) { |count| "lead#{count}@example.com" }

  factory :customer_lead do
    email { FactoryGirl.generate(:lead_email) }
    name "Almighty Customer"
    phone_number "+919845643"
    message "dark and dusty roads."
    after_build {|cl|
      business = cl.business || FactoryGirl.create(:business)
      cl.business = business
      cl.product ||= FactoryGirl.create(:product, business: business)
    }
  end
end
