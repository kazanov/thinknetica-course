class Api::V1::AnswersController < Api::V1::BaseController
  authorize_resource

  def index
    @answers = Answer.all
    respond_with @answers
  end

  def show
    respond_with @answer = Answer.find(params[:id])
  end

  def create
    @question = Question.find(params[:question_id])
    respond_with @answer = @question.answers.create(answer_params.merge(user: current_resource_owner))
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
