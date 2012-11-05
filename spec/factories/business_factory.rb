# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :business do
    name "MyString"
    latitude "MyString"
    longitude "MyString"
    foreground "MyString"
    background "MyString"
    email "business@example.com"
    phone "+919740313399"
    address "shire and frodo"
  end
end

