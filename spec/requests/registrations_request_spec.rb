require 'rails_helper'

RSpec.describe RegistrationsController, type: :request do
  let(:url) { "/registrations" }
  let(:username) { "timchipperfield" }
  let(:password) { "4$55secret_passwordo50" }
  let(:params) do
    {
      username: username,
      password: password,
      password_confirmation: password
    }
  end

  before { Redis.new.flushall }

  context "when the user does not exist already" do
    before { post url, params: params }

    it "returns successful response with the auth header", :aggregate_failures do
      expect(response.status).to eq(200)
      expect(response.headers[JWTSessions.access_header]).to be_present
    end
  end

  context "when user exists already" do
    before do
      User.create_new(username, password, password)
      post url, params: params
    end

    it 'returns unathorized status' do
      expect(response.status).to eq 401
      expect(response.body).to eq("") # not expicit here to avoid hacking
    end
  end

  context "when the password and password_confirmation do not match" do
    let(:params) do
      {
        username: username,
        password: password,
        password_confirmation: "something_34543_not_maching"
      }
    end

    before do
      post url, params: params
    end

    it 'returns unathorized status', :aggregate_failures do
      expect(response.status).to eq 401
      expect(JSON.parse(response.body)["error"]).to eq("password does not match confirmation")
    end
  end

  context "when the password is too weak" do
    let(:params) do
      {
        username: username,
        password: "password",
        password_confirmation: "password"
      }
    end

    before do
      post url, params: params
    end

    it 'returns unathorized status', :aggregate_failures do
      expect(response.status).to eq 401
      expect(JSON.parse(response.body)["error"]).to eq("password is too weak")
    end
  end

  context 'when parameters missing' do
    before do
      post url
    end

    it 'returns unathorized status', :aggregate_failures do
      expect(response.status).to eq 401
      expect(JSON.parse(response.body)["error"]).to eq("password missing")
    end
  end
end
