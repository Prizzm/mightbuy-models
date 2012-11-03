FactoryGirl.define do
  factory :business_url do
    domain "www.example.com"
    after_build do |bu|
      bu.business ||= FactoryGirl.create(:business)
    end
  end
end
