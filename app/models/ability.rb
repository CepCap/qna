class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    guest_abilities
    can :create, :all
    cannot [:create, :update, :destroy], Award
    can [:update, :destroy], [Question, Answer], author: user
    can [:update, :destroy], Comment, user: user
    can [:update, :destroy], Link, linkable: { author: user }
    can :pick_best, Answer
    cannot :pick_best, Answer, author: user
  end

  def admin_abilities
    can :manage, :all
  end
end
