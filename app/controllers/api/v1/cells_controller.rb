class Api::V1::CellsController < ApplicationController
  def flag
    @cell = Cell.find(params[:id])
    unless @cell.revealed
      @cell.flagged = true
      @cell.save
      render json: @cell
    end
  end

  def reveal
    @cell = Cell.find(params[:id])
    unless @cell.flagged
      @cell.revealed = true
      @cell.save
      render json: @cell
    end
  end
end
