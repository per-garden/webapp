require 'securerandom'

FactoryGirl.define do
  factory :api_session, class: 'Api::Session' do
    api_token ""
    user

    factory :logged_in_session do
      api_token SecureRandom.hex
    end
  end
end
