class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer], author_id: user.id
    can :destroy, [Question, Answer, File], author_id: user.id
    can :set_best_answer, Question, author_id: user.id
    can :destroy, ActiveStorage::Attachment, { record: { author_id: user.id } }
    can :destroy, Link, { linkable: { author_id: user.id } }
    can :me, User, user_id: user.id

    can :vote, [Question, Answer] do |resource|
      !user.is_author?(resource)
    end
    can :unvote, [Question, Answer] do |resource|
      user.voted_for?(resource)
    end
  end
end
