class LoginsController < ApplicationController
  def create
    user = User.authenticate(login_params[:username], login_params[:password])
    return head :unauthorized unless user

    expiry_seconds = JWTSessions.access_exp_time
    payload = { username: login_params[:username], exp: expiry_seconds }
    session = JWTSessions::Session.new(
      payload: payload,
      access_exp: expiry_seconds,
      refresh_by_access_allowed: true
    )
    response.set_header("Authorization", session.login[:access])

    render json: payload, status: :ok
  end

  def login_params
    params.permit(:password, :username)
  end
end
