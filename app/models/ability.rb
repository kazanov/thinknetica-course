class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if @user
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

  def vote_abilities
    can [:vote_up, :vote_down], [Question, Answer] do |votable|
      votable.able_to_vote(@user)
    end
    can :remove_vote, [Question, Answer] do |votable|
      votable.voted_by?(@user)
    end
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Attachment, Subscription]
    can [:update, :destroy], [Question, Answer], user_id: @user.id
    can :destroy, Subscription, user_id: @user.id
    can :best_answer, Answer, question: { user_id: @user.id }
    vote_abilities
    can :me, User, id: user.id
  end
end
