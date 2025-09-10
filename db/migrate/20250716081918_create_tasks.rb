class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.references :user, null: false, foreign_key: true
      t.boolean :is_done, default: false
      t.boolean :important, default: false
      t.date :due_date
      t.integer :priority, default: 1
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
