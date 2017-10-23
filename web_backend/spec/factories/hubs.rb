FactoryGirl.define do
  factory :hub, class: 'Hub' do
    sequence(:name) { Faker::Lorem.word.capitalize }
  end
end
