class RemoveSolutionFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :solution, :integer
  end
end
