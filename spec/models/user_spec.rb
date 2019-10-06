require 'rails_helper'

RSpec.describe 'User' do
  let(:username) { "timchipperfield" }
  let(:password) { "4$55secret_passwordo50" }
  let(:password_confirmation) { "4$55secret_passwordo50" }

  describe "authenticate" do
    before do
      Redis.new.flushall
      User.create_new("timchipperfield", password, password_confirmation)
    end

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
      it "returns false" do
        expect(User.authenticate(username, "fake_password")).to eq(false)
      end
    end
  end

  describe "#create_new" do
    let(:username) { "timchipperfield" }

    context "when the password matches the password_confirmation" do
      it "adds the user with a hashed password to redis" do
        User.create_new(username, password, password_confirmation)
        expect(Redis.new.get(username)).to be_a(String)
      end
    end

    context "when the password doesn't match the password_confirmation" do
      it "raises an error" do
        expect { User.create_new(username, password, "fake_password") }
          .to raise_error(PasswordCheckable::PasswordMismatchError)
      end
    end

    context "when weak passwords are used" do
      context "when short password" do
        it "raises an error" do
          expect { User.create_new(username, "£gt66", "£gt66") }
            .to raise_error(PasswordCheckable::PasswordNotStrongError)
        end
      end

      context "when complexity is low" do
        it "raises an error" do
          expect { User.create_new(username, "password", "password") }
            .to raise_error(PasswordCheckable::PasswordNotStrongError)
        end
      end
    end
  end
end
