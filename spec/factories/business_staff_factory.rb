FactoryGirl.define do
  sequence(:business_staff_email) {|count| "business_staff#{count}@example.com" }

  factory :business_staff do
    business { Factory(:business)  }
    email    { FactoryGirl.generate(:business_staff_email) }
    password "password"
    password_confirmation "password"
    name "Joe Doe"
  end
end
