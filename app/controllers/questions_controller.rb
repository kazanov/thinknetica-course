class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, except: [:index, :show]
  before_action :find_question, only: [:show, :destroy, :update, :check_author]
  before_action :check_author, only: [:update, :destroy]
  before_action :build_answer, only: :show
  after_action  :publish_question, only: :create

  respond_to :js
  respond_to :json, only: :create

  authorize_resource

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
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params)
    respond_with(@question)
  end

  def destroy
    respond_with(@question.destroy)
  end

  private

  def publish_question
    PrivatePub.publish_to('/questions', question: @question.to_json) if @question.valid?
  end

  def build_answer
    @answer = @question.answers.new
    @answer.attachments.new
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
