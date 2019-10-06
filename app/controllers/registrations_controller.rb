class RegistrationsController < ApplicationController

  def create
    return head :unauthorized if User.user_exists?(create_params[:username])

    user = User.create_new(
      create_params[:username],
      create_params[:password],
      create_params[:password_confirmation]
    )
    return head :unauthorized unless user

    payload = { username: create_params[:username] }
    session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
    response.set_header("Authorization", session.login[:access])
    head :ok
  end

  private

  def create_params
    params.permit(:username, :password, :password_confirmation)
  end
end
