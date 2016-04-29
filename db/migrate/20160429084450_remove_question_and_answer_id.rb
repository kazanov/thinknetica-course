class RemoveQuestionAndAnswerId < ActiveRecord::Migration
  def change
    remove_column :questions, :question_id, :integer
    remove_column :answers, :answer_id, :integer
  end
end
