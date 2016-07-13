class SearchController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :load_params, only: :index

  def index
    respond_with @result = Search.find(@query, @type)
  end

  private

  def load_params
    @query = params[:query]
    @type = params[:type]
  end
end
