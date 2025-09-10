class CreateReviews < ActiveRecord::Migration[7.0]
  def change
    create_table :reviews do |t|
      t.references :movie, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.integer :rating, null: false, comment: "1-5 stars"
      t.text :comment
      t.integer :status, default: 0, comment: "0: pending, 1: approved, 2: rejected"

      t.timestamps
    end

    add_index :reviews, [:movie_id, :player_id], unique: true, name: 'index_reviews_unique'
    add_index :reviews, :rating
    add_index :reviews, :status

    add_check_constraint :reviews, "rating >= 1 AND rating <= 5", name: "reviews_rating_check"
  end
end