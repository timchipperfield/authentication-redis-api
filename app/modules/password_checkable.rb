module PasswordCheckable
  class PasswordMismatchError < StandardError; end
  class PasswordNotStrongError < StandardError; end

  def validate_passwords!(password, password_confirmation)

    check_matching(password, password_confirmation) && verify_strength(password)
  end

  private

  def check_matching(password, password_confirmation)
    raise PasswordMismatchError unless password == password_confirmation
    true
  end

  def verify_strength(password)
    checker = StrongPassword::StrengthChecker.new(min_word_length: 8, min_entropy: 30)
    raise PasswordNotStrongError unless checker.is_strong?(password)
    true
  end
end
