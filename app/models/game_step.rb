class GameStep < ActiveRecord::Base
    belongs_to :game
    serialize :cards_dealt_to_player, Array
    serialize :cards_dealt_to_dealer, Array
    enum move_type: {
        deal: 0,
        hit: 1,
        stand: 2
    }
end
