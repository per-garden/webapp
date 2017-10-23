require 'rails_helper'

RSpec.describe Hub, type: :model do
  it "has a valid factory" do
    expect(build :hub).to be_valid
  end

end
