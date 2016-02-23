class GameStep < ActiveRecord::Base
    belongs_to :game
    serialize :cards_dealt_to_player, Array
    serialize :cards_dealt_to_dealer, Array
    enum move_type: {
        deal: 0,
        hit: 1,
        stand: 2
    }
    delegate :card_stack, to: :game

    def player_cards_values
        obj = card_stack.values_at *self.cards_dealt_to_player
        obj.map do |c| c.value end
    end

    def dealer_cards_values
        obj = card_stack.values_at *self.cards_dealt_to_dealer
        obj.map do |c| c.value end
    end

    private



end
