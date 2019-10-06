class AuthorizationsController < ApplicationController
  include JWTSessions::RailsAuthorization

  before_action :authorize_refresh_by_access_request!

  def create
    session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
    token = session.refresh_by_access_payload
    response.set_header("Authorization", token[:access])
    render json: user_payload, head: :ok
  end

  private

  def user_payload
    claimless_payload.slice("username", "exp")
  end
end
