class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy, :update, :check_author]
  before_action :check_author, only: [:update, :destroy]
  before_action :build_answer, only: :show

  respond_to :js
  respond_to :json, only: :create

  def index
    respond_with(@questions = Question.all)
  end

  def new
    respond_with(@question = current_user.questions.new)
  end

  def show
    respond_with @question
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      PrivatePub.publish_to '/questions', question: @question.to_json
      redirect_to @question
    else
      render :new
    end
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def build_answer
    @answer = @question.answers.new
  end

  def check_author
    redirect_to @question unless current_user.author_of?(@question)
  end

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
  end
end
