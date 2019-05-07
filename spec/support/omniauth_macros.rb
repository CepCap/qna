module OmniauthMacros
  def github_mock
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '123545',
      info: { 'email' => 'user@email.com' })
  end

  def vk_mock
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
      provider: 'vkontakte',
      uid: '123545',
      info: { 'email' => nil })
  end

  def invalid_mock
    OmniAuth.config.mock_auth[:github] = :invalid
  end
end
