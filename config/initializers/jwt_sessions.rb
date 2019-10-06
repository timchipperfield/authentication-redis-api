JWTSessions.algorithm = "HS256"
JWTSessions.encryption_key = ENV["SECRET_ENCRYPTION_KEY"]
JWTSessions.token_store = :redis, { redis_url: 'redis://127.0.0.1:6379/0' }
