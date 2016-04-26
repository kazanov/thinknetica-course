class AddQuestionIdAndAnswerIdToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :question_id, :integer
    add_column :answers, :answer_id, :integer
    add_index  :answers, :answer_id
  end
end
