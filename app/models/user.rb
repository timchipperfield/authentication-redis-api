class User
  include BCrypt

  def self.authenticate(username, password)
    password_hash = redis.get(username)
    return false unless password_hash

    decrypted_password(password_hash) == password
  end

  def self.create_new(username, password, password_confirmation)
    validate_passwords!(password, password_confirmation)

    hashed_password = Password.create(password)
    redis.set(username, hashed_password)
  end

  private

  class << self
    include BCrypt
    include PasswordCheckable

    def redis
      @redis ||= Redis.new
    end

    def decrypted_password(password_hash)
      @descrypted_password ||= Password.new(password_hash)
    end
  end
end
