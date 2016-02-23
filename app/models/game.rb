class Game < ActiveRecord::Base
    # State machine for controlling the state of the game
    include AASM
    cattr_accessor :card_stack
    @@num_card_decks = 6
    # Storing the all 6 deck of card objects in this array
    @@card_stack = Array.new(@@num_card_decks , CardDeck.new(%w{ 11 2 3 4 5 6 7 8 9 10 10 10 10}).deck_of_cards).flatten

    serialize :cards_dealt, Array
    has_many :game_steps
    has_one :game_stat

    enum state: {
        started: 0,
        player_move: 1,
        ended: 2
    }
    enum winner: {
        dealer: DEALER,
        player: PLAYER
    }

    aasm :column => :state, :enum => true do
        state :started, :initial => true, :after_enter => :deal_initial_hands
        state :player_move, :after_enter => :greater_than_equal_to_21?
        state :ended

        event :control_to_player do
            transitions :from => [:started], :to => :player_move
        end

        event :end_game do
            transitions :from => [:player_move], :to => :ended, :after => :store_stats
        end

    end


    def self.start_game bet_amt
        game = Game.new.tap do |g|
            g.bet_amount = bet_amt
            g.save
        end
    end

    def hit
        self.cards_dealt << pick_random_card_from_available_cards
        self.save
        self.game_steps.create(move_type: 'hit',cards_dealt_to_player: [self.cards_dealt.last])
        greater_than_equal_to_21?
    end

    def stand
        self.cards_dealt << pick_random_card_from_available_cards
        self.save
        self.game_steps.create(move_type: 'stand',cards_dealt_to_dealer: [self.cards_dealt.last])
        unless greater_than_equal_to_21?
            @dealer_scores = dealer_score
            @player_scores = player_score
            if @dealer_scores <= 16
                stand
            else
                if @player_scores > @dealer_scores
                    self.winner = PLAYER
                elsif @dealer_scores > @player_scores
                    self.winner = DEALER
                end
                end_game!
            end
        end
    end



    def greater_than_equal_to_21?
        puts "player score is #{player_score}, dealer_score is #{dealer_score}"
        @player_scores = player_score
        @dealer_scores = dealer_score
        if @player_scores > 21 || @dealer_scores == 21
            self.winner = DEALER
        elsif @dealer_scores > 21 || @player_scores == 21
            self.winner = PLAYER
        else
            return false
        end
        self.ended_at = Time.now
        end_game!   
        return true
    end

    def player_score
        player_cards.inject(0){|sum,e|
            sum += e.value.to_i}
    end

    def dealer_score
        dealer_cards.inject(0){|sum,e| sum += e.value.to_i}
    end

    def player_cards
        cards_dealt_to_player = []
        self.game_steps.each do |s|
            cards_dealt_to_player.concat s.cards_dealt_to_player
        end
        @player_card_objects = @@card_stack.values_at *cards_dealt_to_player
    end

    def dealer_cards
        cards_dealt_to_dealer = []
        self.game_steps.each do |s|
            cards_dealt_to_dealer.concat s.cards_dealt_to_dealer
        end
        @dealer_card_objects = @@card_stack.values_at *cards_dealt_to_dealer
    end




    def deal_initial_hands
        # Picking three cards randomly to give 2 cards to player and 1 to dealer
        self.cards_dealt << pick_random_card_from_available_cards
        self.cards_dealt << pick_random_card_from_available_cards
        self.cards_dealt << pick_random_card_from_available_cards
        self.save
        self.game_steps.create(move_type: 'deal',cards_dealt_to_player: self.cards_dealt[0..1],cards_dealt_to_dealer: self.cards_dealt[2..2])
        self.control_to_player
    end

    private

    def store_stats
        GameStat.create(player_score: @player_scores,dealer_score: @dealer_scores,game_id: self.id)
    end

    def pick_random_card_from_available_cards
        loop do
            card_stack_index = rand(312)
            unless self.cards_dealt.include? card_stack_index
                return card_stack_index
            end
        end
    end

end
