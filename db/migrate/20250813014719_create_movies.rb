class CreateMovies < ActiveRecord::Migration[7.0]
  def change
    create_table :movies do |t|
      t.string :title, null: false
      t.text :description
      t.string :genre
      t.integer :duration, comment: "Duration in minutes"
      t.string :poster_url
      t.string :age_rating, comment: "P, T13, T16, T18"
      t.integer :status, default: 0, comment: "0: active, 1: inactive, 2: coming_soon"

      t.timestamps
    end

    add_index :movies, :status
    add_index :movies, :title
  end
end
