class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:update, :destroy, :best_answer]
  before_action :check_author, only: [:update, :destroy]

  respond_to :js

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def update
    respond_with(@answer.update(answer_params))
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def best_answer
    @answer.make_best! if current_user.author_of?(@answer.question)
    redirect_to @answer.question
  end

  private

  def check_author
    redirect_to @answer.question unless current_user.author_of?(@answer)
  end

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
