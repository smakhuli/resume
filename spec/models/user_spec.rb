require 'rails_helper'

RSpec.describe User, type: :model do

  before(:all) do
    @user1 = create(:user)
  end

  context "validations" do
    it "is valid with valid attributes" do
      expect(@user1).to be_valid
    end

    it "is not valid without a password" do
      user = build(:user, password: nil)
      expect(user).to_not be_valid
    end

    it "is not valid without a first name" do
      user = build(:user, first_name: nil)
      expect(user).to_not be_valid
    end

    it "is not valid without a last name" do
      user = build(:user, last_name: nil)
      expect(user).to_not be_valid
    end

    it "is not valid without an email" do
      user = build(:user, email: nil)
      expect(user).to_not be_valid
    end

    it "is not valid without a valid email" do
      user = build(:user, email: 'joe#gmail.com')
      expect(user).to_not be_valid
    end

    it "must have a unique email" do
      user = create(:user)
      user2 = build(:user, first_name: 'Jim', email: user.email)
      expect(user2).to_not be_valid
    end

  end
end
