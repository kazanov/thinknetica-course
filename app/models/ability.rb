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
      votable.votes.find_by(user_id: @user.id).nil? && !@user.author_of?(votable)
    end
    can :remove_vote, [Question, Answer] do |votable|
      votable.votes.find_by(user_id: @user.id) && !@user.author_of?(votable)
    end
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Attachment]
    can [:update, :destroy], [Question, Answer], user_id: @user.id
    can :best_answer, Answer, question: { user_id: @user.id }
    vote_abilities
  end
end
