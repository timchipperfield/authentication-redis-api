class ApplicationController < ActionController::API
  rescue_from PasswordCheckable::PasswordNotStrongError, with: :not_authorized_password_strength

  rescue_from PasswordCheckable::PasswordMismatchError, with: :not_authorized_mismatch

  rescue_from PasswordCheckable::PasswordMissingError do |exception|
    render json: { error: exception }, status: :unauthorized
  end

  rescue_from JWTSessions::Errors::Unauthorized do |exception|
    render json: { error: exception }, status: :unauthorized
  end

  def not_authorized_mismatch
    render json: { error: "password does not match confirmation" }, status: :unauthorized
  end

  def not_authorized_password_strength
    render json: { error: "password is too weak" }, status: :unauthorized
  end
end
