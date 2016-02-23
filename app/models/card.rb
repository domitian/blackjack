class Card

  attr_accessor :number, :suit, :value

  def initialize(number, suit, value)
    @number = number
    @suit = suit
    @value = value
  end

  def to_s
    "#{@number} of #{@suit}"
  end
end

