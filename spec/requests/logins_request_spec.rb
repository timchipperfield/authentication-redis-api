require 'rails_helper'

RSpec.describe LoginsController, type: :request do
  let(:url) { "/logins" }
  let(:username) { "timchipperfield" }
  let(:password) { "4$55secret_passwordo50" }
  let(:params) do
    {
      username: username,
      password: password
    }
  end

  before { Redis.new.flushall }

  context "when user exists" do
    before do
      User.create_new(username, password, password)
      post url, params: params
    end

    it "returns successful response with the auth header", :aggregate_failures do
      expect(response.status).to eq(200)
      expect(response.headers[JWTSessions.access_header]).to be_present
    end
  end

  context "when the user does not exist already" do
    before { post url, params: params }

    it 'returns unathorized status' do
      expect(response.status).to eq 401
    end
  end

  context "when the user exists but the password is incorrect" do
    let(:password) { "4$55secret_passwordo50" + "1" }

    before do
      User.create_new(username, password, password)
      post url, params: params
    end

    it 'returns unathorized status' do
      expect(response.status).to eq 401
    end
  end

  context 'when parameters missing' do
    before do
      User.create_new(username, password, password)
      post url
    end

    it 'returns unathorized status' do
      expect(response.status).to eq 401
    end
  end
end