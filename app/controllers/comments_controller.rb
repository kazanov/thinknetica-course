class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_commentable

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.js do
          PrivatePub.publish_to '/comments', comment: @comment.to_json, commentable_type: @commentable.class.name.underscore,
                                             commentable_id: @commentable.id, user_email: @comment.user.email
          render nothing: true
        end
      else
        format.js
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text)
  end

  def model_klass
    commentable_type.classify.constantize
  end

  def commentable_type
    params[:commentable].singularize
  end

  def find_commentable
    @commentable = model_klass.find(params["#{commentable_type}_id"])
  end
end
