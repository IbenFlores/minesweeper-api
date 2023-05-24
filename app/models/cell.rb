class Cell < ApplicationRecord
  belongs_to :game

  after_save :change_game_status

  def change_game_status
    if has_mine && revealed
      game.status = 'lost'
      game.save
    elsif game.cells.where(revealed: false).count.zero? && game.cells.where(has_mine: true).count == game.mines
      game.status = 'won'
      game.save
    end
  end
end
