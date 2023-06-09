class Game < ApplicationRecord
  has_many :cells, dependent: :destroy
  after_create :set_field

  def as_json(options = {})
    super(only: [:id, :status, :mines, :size], methods: :field)
  end

  def field
    field_string = self[:field]
    parse_field_string(field_string)
  end

  private

  def parse_field_string(field_string)
    rows = field_string.scan(/\[(.*?)\]/)
    rows.map do |row|
      row[0].scan(/#<Cell.*?>/).map do |cell_string|
        cell_id = cell_string.match(/id: (\d+)/)[1].to_i
        Cell.find(cell_id)
      end
    end
  end

  def set_field
    new_field = []
    size.times do
      new_field << Array.new(size) { Cell.new(game_id: id, adjacent_mines: 0) }
    end
    p "there are going to be #{mines} mines"
    mines.times do
      row = rand(size)
      col = rand(size)
      mined_cell = new_field[row][col]
      p mined_cell
      mined_cell.has_mine = true
      mined_cell.save
    end

    new_field.each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|
        # Add adjacent mines if same left and right cells have mines
        cell.adjacent_mines += 1 if row[col_index + 1].try(:has_mine) || row[col_index - 1].try(:has_mine)
        # Add adjacent mines if same top and bottom cells have mines
        cell.adjacent_mines += 1 if new_field[row_index + 1].try(:[], col_index).try(:has_mine) || new_field[row_index - 1].try(:[], col_index).try(:has_mine)
        # Add adjacent mines if diagonal cells have mines
        cell.adjacent_mines += 1 if new_field[row_index - 1].try(:[], col_index - 1).try(:has_mine)
        cell.adjacent_mines += 1 if new_field[row_index - 1].try(:[], col_index + 1).try(:has_mine)
        cell.adjacent_mines += 1 if new_field[row_index + 1].try(:[], col_index - 1).try(:has_mine)
        cell.adjacent_mines += 1 if new_field[row_index + 1].try(:[], col_index + 1).try(:has_mine)
        cell.save
      end
    end

    self.field = new_field
    save
  end
end
