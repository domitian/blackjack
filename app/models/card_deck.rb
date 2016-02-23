class CardDeck 
    attr_reader :deck_of_cards
    def initialize values
        #values = %w{ 11 2 3 4 5 6 7 8 9 10 10 10 10} For blackjack these are values, but other games this could vary.
        @deck_of_cards = []
        ranks = %w{A 2 3 4 5 6 7 8 9 10 J Q K}
        suits = %w{Spades Hearts Diamonds Clubs}
        suits.each do |suit|
          ranks.size.times do |i|
            @deck_of_cards << Card.new( ranks[i], suit, values[i])
          end
        end
    end

    
end

