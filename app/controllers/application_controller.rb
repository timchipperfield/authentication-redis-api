class ApplicationController < ActionController::API
  rescue_from PasswordCheckable::PasswordNotStrongError, with: :not_authorized
  rescue_from PasswordCheckable::PasswordMismatchError, with: :not_authorized
  rescue_from JWTSessions::Errors::Unauthorized, with: :not_authorized

  def not_authorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end
end
