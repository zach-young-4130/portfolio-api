require "jwt"

class JsonWebToken
  ALGORITHM = "HS256".freeze
  DEFAULT_EXP = 7.days

  def self.encode(payload, exp: DEFAULT_EXP.from_now)
    JWT.encode(payload.merge(exp: exp.to_i), secret, ALGORITHM)
  end

  def self.decode(token)
    JWT.decode(token, secret, true, algorithm: ALGORITHM).first
  rescue JWT::DecodeError, JWT::ExpiredSignature
    nil
  end

  def self.secret
    Rails.application.secret_key_base
  end
end
