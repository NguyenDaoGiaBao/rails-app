class CreateClubs < ActiveRecord::Migration[8.0]
  def change
    create_table :clubs do |t|
      t.string :name
      t.string :est
      t.string :logo
      t.string :cover
      t.string :stadium
      t.timestamps
    end
  end
end
