module OmniauthMacros
  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.downcase.to_sym] = OmniAuth::AuthHash.new({
      provider: provider.downcase,
      uid: '1235456',
      info: { email: 'user@mail.com' },
      credentials: { token: 'mock_token' }
    })
  end

  def invalid_mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.downcase.to_sym] = :invalid_credentials
  end
end
