require 'rails_helper'

RSpec.describe 'User' do

  describe "authenticate" do
    before do
      Redis.new.flushall
      User.create_new("timchipperfield", "secret_password", "secret_password")
    end

    let(:username) { "timchipperfield" }
    let(:password) { "secret_password" }
    let(:password_confirmation) { "secret_password" }

    context "when the user exists and the password is correct" do
      it "returns true" do
        expect(User.authenticate(username, password)).to eq(true)
      end
    end

    context "when the user doesn't exist" do
      let(:username) { "mrfake" }

      it "returns false" do
        expect(User.authenticate(username, password)).to eq(false)
      end
    end

    context "when the password is incorrect" do
      let(:password) { "fake_password" }

      it "returns false" do
        expect(User.authenticate(username, password)).to eq(false)
      end
    end
  end

  describe "#create_new" do
    let(:username) { "timchipperfield" }

    context "when the password matches the password_confirmation" do
      it "adds the user with a hashed password to redis" do
        User.create_new(username, "secret_password", "secret_password")
        expect(Redis.new.get(username)).to be_a(String)
      end
    end

    context "when the password doesn't match the password_confirmation" do
      it "raises an error" do
        expect { User.create_new(username, "secret_password", "fake_password") }
          .to raise_error(User::PasswordMismatch)
      end
    end
  end
end
