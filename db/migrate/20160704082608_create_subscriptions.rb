class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :user
      t.references :question

      t.timestamps null: false
    end
    add_index :subscriptions, :user_id
    add_index :subscriptions, :question_id
    add_index :subscriptions, [:user_id, :question_id], unique: true
  end
end
