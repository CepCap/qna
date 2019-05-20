class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github, :vkontakte]

  has_many :questions
  has_many :answers
  has_many :awards
  has_many :authorizations

  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy

  def author_of?(instance)
    self.id == instance.user_id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end
end
