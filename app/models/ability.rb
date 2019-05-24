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
    can [:update, :destroy], [Question, Answer], author_id: user.id
    can [:update, :destroy], Comment, user_id: user.id
    can [:update, :destroy], Link, linkable: { author_id: user.id }
    can :pick_best, Answer
    can :me, User, id: user.id
    cannot :pick_best, Answer, author_id: user.id
    can :subscribe, Question
    can :unsubscribe, Question, subscriptions: { user_id: user.id }
  end

  def admin_abilities
    can :manage, :all
  end
end
