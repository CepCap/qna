module Services
  class FindForOauth
    attr_reader :auth
    attr_reader :confirm

    def initialize(auth)
      @auth = auth
    end

    def call
      authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
      return authorization.user if authorization

      email = auth.info[:email]
      user = User.find_by(email: email)

      if user
        user.authorizations.create(provider: auth.provider, uid: auth.uid)
      else
        password = Devise.friendly_token[0, 20]
        user = User.new(email: email, password: password, password_confirmation: password)
        if email
          user.skip_confirmation! unless auth.confirm
          user.save!
          user.authorizations.create!(provider: auth.provider, uid: auth.uid)
        end
      end
      user
    end
  end
end
