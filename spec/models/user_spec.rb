require 'rails_helper'

RSpec.describe User, type: :model do

  let(:first_name) { Faker::Name.unique.first_name }
  let(:last_name) { Faker::Name.unique.last_name }
  let(:phone_number) { Faker::PhoneNumber.cell_phone }
  let(:email) { Faker::Internet.email }
  let(:username) { Faker::Internet.username }
  let(:password) { '123456' }

  let(:user) {
    FactoryBot.build(
      :user,
        first_name: first_name,
        last_name: last_name,
        phone_number: phone_number,
        email: email,
        username: username,
        password: password,
    )
  }

  it "should have valid first name" do
    user.skip_confirmation!
    user.save
    expect(user.valid?).to be true
    user.destroy
  end


end
