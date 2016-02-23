class GamesController < ApplicationController
    
    before_action :set_game, only: [:show,:winner,:hit,:stand]
    def index

    end


    def start_game
        @game = Game.start_game(params[:bet_amount] || 100)
        redirect_to @game
    end

    def show
        if @game.player_move?
            @steps = @game.game_steps
        elsif @game.ended?
            redirect_to winner_game_url(@game)
        end
    end

    def hit
        if @game.player_move?
            @game.hit
        end
        redirect_to @game
    end

    def stand
        @game.stand if @game.player_move?
        redirect_to @game
    end

    def stats
        @games = Game.includes(:game_stat).all
        puts @games.inspect
    end

    def winner
        
    end


    private

    def set_game
        @game=Game.find(params[:id])
    end
end
