class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy]

  def index
    @questions = Question.all
  end

  def new
    @question = current_user.questions.new
  end

  def show
    @answer = @question.answers.build
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Question successfully created.'
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to root_path, notice: 'Question successfully deleted.'
    else
      redirect_to @question, alert: 'You are not allowed to delete this question.'
    end
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
