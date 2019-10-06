class LoginsController < ApplicationController
  before_action :unauthorized_unless_user

  def create
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

  private

  def unauthorized_unless_user
    return head :unauthorized unless user
  end

  def user
    @user ||= User.authenticate(login_params[:username], login_params[:password])
  end

  def login_params
    params.permit(:password, :username)
  end
end
