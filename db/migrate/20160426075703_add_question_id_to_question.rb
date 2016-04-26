class AddQuestionIdToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :question_id, :integer
    add_index  :questions, :question_id
  end
end
