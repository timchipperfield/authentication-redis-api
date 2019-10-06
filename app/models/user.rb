class User
  def self.authenticate(username, password)
    found_password = redis.get(username)
    return nil unless found_password

    password == found_password
  end

  private

  class << self
    def redis
      @redis ||= Redis.new
    end
  end
end
