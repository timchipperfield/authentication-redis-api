require 'rails_helper'

RSpec.describe 'login and then authorize', type: :request do
  before { Redis.new.flushall }

  context "when user exists" do
    let(:username) { "timchipperfield" }
    let(:login_params) do
      {
        username: username,
        password: "4$55secret_passwordo50"
      }
    end

    it "returns successful response with the auth header", :aggregate_failures do
      User.create_new("timchipperfield", "4$55secret_passwordo50", "4$55secret_passwordo50")

      post '/logins', params: login_params

      token = response.headers[JWTSessions.access_header]

      post '/authorizations', headers: { JWTSessions.access_header => "Bearer #{token}" }

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["username"]).to eq(username)
    end
  end
end
