require 'rails_helper'

RSpec.describe "POST /login", type: :request do
  let(:url) { "/login" }
  let(:username) { "timchipperfield" }
  let(:password) { "secret_password" }
  before { Redis.new.flushall }

  let(:params) do
    {
      username: username,
      password: password
    }
  end

  context "when user exists" do
    before do
      Redis.new.set(username, password) # creates the user beforehand
      post url, params: params
    end

    it "returns successful response with the auth header", :aggregate_failures do
      expect(response.status).to eq(200)
      expect(response.headers['Authorization']).to be_present
    end
  end

  context "when the user does not exist already" do
    before { post url, params: params }

    it 'returns unathorized status' do
      expect(response.status).to eq 401
    end
  end

  context "when the user exists but the password is incorrect" do
    let(:password) { "bad_password" }

    before { post url, params: params }

    it 'returns unathorized status' do
      expect(response.status).to eq 401
    end
  end

  context 'when parameters missing' do
    before { post url }

    it 'returns unathorized status' do
      expect(response.status).to eq 401
    end
  end
end
