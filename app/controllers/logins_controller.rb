class LoginsController < ApplicationController
  def create
    user = User.authenticate(register_params[:username], register_params[:password])
    return head :unauthorized unless user

    payload = { username: register_params[:username] }
    session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
    response.set_header("Authorization", session.login[:access])
    head :ok
  end

  def register_params
    params.permit(:password, :username)
  end
end
