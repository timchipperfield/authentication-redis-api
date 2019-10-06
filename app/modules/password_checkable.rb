module PasswordCheckable
  class PasswordMismatchError < StandardError; end
  class PasswordNotStrongError < StandardError; end
  class PasswordMissingError < StandardError; end

  def validate_passwords!(password, password_confirmation)
    check_password_exists(password, password_confirmation)
    check_matching(password, password_confirmation)
    verify_strength(password)
  end

  private

  def check_password_exists(password, password_confirmation)
    if password.blank?
      error = "password"
    elsif password_confirmation.blank?
      error = "password_confirmation"
    else
      error = nil
    end

    raise PasswordMissingError.new(error + " missing") if error.present?
  end

  def check_matching(password, password_confirmation)
    raise PasswordMismatchError unless password == password_confirmation
  end

  def verify_strength(password)
    checker = StrongPassword::StrengthChecker.new(min_word_length: 8, min_entropy: 30)
    raise PasswordNotStrongError unless checker.is_strong?(password)
  end
end
