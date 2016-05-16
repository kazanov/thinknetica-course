class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create, :update, :destroy, :best_answer]
  before_action :find_answer, only: [:update, :destroy, :best_answer]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save && flash[:notice] = 'Answer successfully created.'
  end

  def update
    current_user.author_of?(@answer) && @answer.update(answer_params)
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
    current_user.author_of?(@answer.question) && @answer.make_best!
    redirect_to @answer.question
  end

  private

  def find_answer
    @answer = @question.answers.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
