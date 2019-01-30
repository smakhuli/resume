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

  it "will format 10 digit phone number" do
    expect(@user1.format_phone('5301234567')).to eq '(530) 123-4567'
  end

  it "checks for ownership" do
    expect(@user1.is_owner?(@user1)).to eq true
    user2 = create(:user)
    expect(@user1.is_owner?(user2)).to eq false
  end

  it "checks if user is admin" do
    user = build(:user)
    expect(user.is_admin?).to eq false
    user2 = build(:user, role: 'admin')
    expect(user2.is_admin?).to eq true
  end

  it "puts signed in user's resume at front of queue" do
    user1 = build(:user)
    user1.save!

    user2 = build(:user)
    user2.save!

    user3 = build(:user)
    user3.save!

    users = user3.get_users
    expect(user3).to eq users.first
  end

  it "checks if user has access" do
    user1 = build(:user)
    user1.save!
    user2 = build(:user)
    user2.save!

    expect(user1.has_access?(user2.id)).to eq false
    expect(user1.has_access?(user1.id)).to eq true

    user1.role = 'admin'
    user1.save!
    expect(user1.has_access?(user2.id)).to eq true
  end

  it "finds public users" do
    expect(User.public.count).to eq User.count

    user1 = build(:user, make_private: true)
    user1.save!

    expect(User.public.count).to_not eq User.count
    expect(User.public.count).to eq (User.count - 1)
  end

end
