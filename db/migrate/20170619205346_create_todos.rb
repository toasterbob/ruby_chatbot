class CreateTodos < ActiveRecord::Migration[5.0]
  def change
    create_table :todos do |t|
      t.string :task, null: false
      t.boolean :completed, null: false
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
