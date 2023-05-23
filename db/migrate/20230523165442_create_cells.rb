class CreateCells < ActiveRecord::Migration[7.0]
  def change
    create_table :cells do |t|
      t.references :game, null: false, foreign_key: true
      t.boolean :has_mine
      t.boolean :revealed
      t.boolean :flagged
      t.integer :adjacent_mines

      t.timestamps
    end
  end
end
