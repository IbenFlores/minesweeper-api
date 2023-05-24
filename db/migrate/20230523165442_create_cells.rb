class CreateCells < ActiveRecord::Migration[7.0]
  def change
    create_table :cells do |t|
      t.references :game, null: false, foreign_key: true
      t.boolean :has_mine, default: false
      t.boolean :revealed, default: false
      t.boolean :flagged, default: false
      t.integer :adjacent_mines

      t.timestamps
    end
  end
end
