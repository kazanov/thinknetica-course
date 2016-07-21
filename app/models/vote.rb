class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true, touch: true
  belongs_to :user

  validates :value, inclusion: [-1, 1]
  validates :user_id, :votable_id, :votable_type, presence: true
end
