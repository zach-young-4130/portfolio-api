module Authentication
  extend ActiveSupport::Concern

  private

  def current_user
    @current_user ||= begin
      payload = ::JsonWebToken.decode(bearer_token)
      User.find_by(id: payload["sub"]) if payload
    end
  end

  def authenticate!
    head :unauthorized unless current_user
  end

  def issue_token(user)
    ::JsonWebToken.encode({ sub: user.id })
  end

  def bearer_token
    header = request.headers["Authorization"]
    return nil unless header&.start_with?("Bearer ")

    header.delete_prefix("Bearer ").strip.presence
  end
end
