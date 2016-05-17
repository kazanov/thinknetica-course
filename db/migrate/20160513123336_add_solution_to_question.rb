class AddSolutionToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :solution, :integer
    add_index  :questions, :solution
  end
end
