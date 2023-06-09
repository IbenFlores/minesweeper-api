class Api::V1::GamesController < ApplicationController
  def index
    @games = Game.pluck(:id)
    render json: { games: @games }
  end

  def show
    game = Game.find(params[:id])
    render json: game
  end

  def create
    @game = Game.new(game_params)
    if @game.save
      render json: @game, status: :created
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  def update
    game = Game.find(params[:id])
    if game.update(game_params)
      rendegr json: game
    else
      render json: game.errors, status: :unprocessable_entity
    end
  end

  def destroy
    game = Game.find(params[:id])
    game.destroy
    head :no_content
  end

  private

  def game_params
    params.require(:game).permit(:field, :size, :mines, :status)
  end
end
