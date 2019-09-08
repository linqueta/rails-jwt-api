# frozen_string_literal: true

module AuthenticationHelper
  def authorize
    user = create(:user,
                  name: 'Authentication User',
                  email: "#{SecureRandom.uuid}test@test.com",
                  password: SecureRandom.uuid)
    request.headers['Authorization'] = ::Auth::JWT.encode(sub: user.id)
  end
end
