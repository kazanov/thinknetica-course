class Comment < ActiveRecord::Base
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :text, :commentable_id, :commentable_type, :user_id, presence: true
end
