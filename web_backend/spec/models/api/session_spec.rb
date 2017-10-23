require 'rails_helper'

RSpec.describe Api::Session, type: :model do
  it "has a valid factory" do
    expect(build :api_session).to be_valid
  end

end
