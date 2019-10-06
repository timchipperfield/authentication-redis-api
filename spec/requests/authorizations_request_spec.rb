require "rails_helper"

RSpec.describe AuthorizationsController, type: :request do
  describe "POST #create" do
    let(:url) { "/authorizations" }
    let(:username) { "timchipperfield" }
    let(:expired_time) { 3600 }
    let(:access_token) { "Bearer #{@tokens[:access]}" }

    before do
      payload = { username: username }
      session = JWTSessions::Session.new(
                  payload: payload,
                  refresh_by_access_allowed: true,
                  access_exp: expired_time
                )
      @tokens = session.login
    end

    context 'when the auth header has a valid access token' do
      it "returns a 200 response with the user data", :aggregate_failures do
        post url, headers: { JWTSessions.access_header => access_token }
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)["username"]).to eq(username)
        expect(JSON.parse(response.body)["exp"]).to be_a(Integer)
        expect(response.headers['Authorization']).not_to equal(@tokens[:access])
      end
    end

    context "when the token is invalid" do
      let(:access_token) { "Bearer #{"fake1234"}" }

      it "returns 401" do
        post url, headers: { JWTSessions.access_header => access_token }
        expect(response.status).to eq(401)
      end
    end

    context "when the auth token is expired" do
      let(:expired_time) { 0 }

      it "returns 401" do
        post url, headers: { JWTSessions.access_header => access_token }
        expect(response.status).to eq(401)
      end
    end

    context "when token is absent" do
      it "returns 401" do
        post url
        expect(response.status).to eq(401)
      end
    end
  end
end
