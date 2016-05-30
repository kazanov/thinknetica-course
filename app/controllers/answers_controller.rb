class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:update, :destroy, :best_answer]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
    # respond_to do |format|
    #   if @answer.save
    #     format.js do
    #       PrivatePub.publish_to "/questions/#{@question.id}/answers", answer: @answer.to_json
    #       render nothing: true
    #     end
    #   else
    #     format.js
    #     render :new
    #   end
    # end
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer successfully deleted.'
    else
      flash[:notice] = 'You are not allowed to delete this question.'
    end
  end

  def best_answer
    @answer.make_best! if current_user.author_of?(@answer.question)
    redirect_to @answer.question
  end

  private

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
