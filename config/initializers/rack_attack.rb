# Throttles abuse on sensitive endpoints. Disabled in test to keep request
# specs deterministic — re-enable per-spec if you want to exercise this.
Rack::Attack.enabled = !Rails.env.test?

class Rack::Attack
  # 5 login attempts per IP per 5 minutes. The 6th returns 429 until the
  # window rolls. Per-account lockout (User#locked?) is the second layer
  # and survives IP rotation.
  throttle("login/ip", limit: 5, period: 5.minutes) do |req|
    req.ip if req.post? && req.path == "/api/v1/session"
  end

  # Always respond with the same JSON envelope every other endpoint uses,
  # so the frontend can type-narrow on { errors: [...] } uniformly.
  self.throttled_responder = lambda do |_request|
    [
      429,
      { "Content-Type" => "application/json" },
      [ { errors: [ "Too many login attempts. Try again later." ] }.to_json ]
    ]
  end
end
