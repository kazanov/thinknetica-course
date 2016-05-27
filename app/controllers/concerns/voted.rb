module Voted
  extend ActiveSupport::Concern

  included do
    before_action :find_votable, only: [:vote_up, :vote_down, :remove_vote]
    before_action :author?, only: [:vote_up, :vote_down, :remove_vote]
  end

  def vote_up
    @votable.vote_up(current_user)
    render json: { model: model_klass.to_s.downcase, id: @votable.id, rating: @votable.rating, voted: true }
  end

  def vote_down
    @votable.vote_down(current_user)
    render json: { model: model_klass.to_s.downcase, id: @votable.id, rating: @votable.rating, voted: true }
  end

  def remove_vote
    @votable.remove_vote(current_user)
    render json: { model: model_klass.to_s.downcase, id: @votable.id, rating: @votable.rating, voted: false }
  end

  private

  def author?
    render nothing: true, status: 403 if current_user.author_of?(@votable)
  end

  def model_klass
    controller_name.classify.constantize
  end

  def find_votable
    @votable = model_klass.find(params[:id])
  end
end
