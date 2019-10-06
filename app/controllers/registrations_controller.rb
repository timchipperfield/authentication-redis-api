class RegistrationsController < ApplicationController
  before_action :unauthorized_if_user_exists

  def create
    return head :unauthorized unless new_user

    expiry_seconds = JWTSessions.access_exp_time
    payload = { username: create_params[:username], exp: expiry_seconds }
    session = JWTSessions::Session.new(
      payload: payload,
      access_exp: expiry_seconds,
      refresh_by_access_allowed: true
    )
    response.set_header("Authorization", session.login[:access])

    render json: payload, status: :ok
  end

  private

  def new_user
    @new_user ||= User.create_new(
      create_params[:username],
      create_params[:password],
      create_params[:password_confirmation]
    )
  end

  def unauthorized_if_user_exists
    return head :unauthorized if User.user_exists?(create_params[:username])
  end

  def create_params
    params.permit(:username, :password, :password_confirmation)
  end
end
