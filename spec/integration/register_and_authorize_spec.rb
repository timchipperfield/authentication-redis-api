require 'rails_helper'

RSpec.describe 'register and then authorize', type: :request do
  before { Redis.new.flushall }

  context "when new user" do
    let(:username) { "timchipperfield" }
    let(:password) { "4$55secret_passwordo50" }

    let(:sign_up_params) do
      {
        username: username,
        password: password,
        password_confirmation: password
      }
    end

    it "returns successful response with the auth header", :aggregate_failures do
      post '/registrations', params: sign_up_params

      token = response.headers[JWTSessions.access_header]

      post '/authorizations', headers: { JWTSessions.access_header => "Bearer #{token}" }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["username"]).to eq(username)
    end
  end
end
