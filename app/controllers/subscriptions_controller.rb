class SubscriptionsController < ApplicationController
  before_action :find_question, only: :create

  respond_to :js

  # authorize_resource

  def create
    authorize! :create, Subscription
    respond_with @subscription = Subscription.create(question: @question, user: current_user)
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    authorize! :destroy, @subscription
    respond_with @subscription.destroy
    # respond_with @subscription.destroy if @subscription.user_id == current_user.id
  end

  private

  def find_question
    @question = Question.find(params[:question_id])
  end
end
