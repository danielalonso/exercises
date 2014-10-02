class Card
  attr_accessor :suite, :name, :value

  def initialize(suite, name, value)
    @suite, @name, @value = suite, name, value
  end
end

class Deck
  attr_accessor :playable_cards
  SUITES = [:hearts, :diamonds, :spades, :clubs]
  NAME_VALUES = {
    :two   => 2,
    :three => 3,
    :four  => 4,
    :five  => 5,
    :six   => 6,
    :seven => 7,
    :eight => 8,
    :nine  => 9,
    :ten   => 10,
    :jack  => 10,
    :queen => 10,
    :king  => 10,
    :ace   => [11, 1]}

  def initialize
    shuffle
  end

  def deal_card
    random = rand(@playable_cards.size)
    @playable_cards.delete_at(random)

  end

  def shuffle
    @playable_cards = []
    SUITES.each do |suite|
      NAME_VALUES.each do |name, value|
        @playable_cards << Card.new(suite, name, value)
      end
    end
  end
end

class Hand
  attr_accessor :cards

  def initialize
    @cards = []
  end

  def hand_value
    sum = 0
    number_of_arrays = 0

    for i in @cards
      if i.value.class != Array
        sum += i.value
      elsif i.value.class == Array
        number_of_arrays += 1
      end
    end

    for i in @cards
      if i.value.class == Array
        if (sum + number_of_arrays) <= 11
          sum += i.value[0]
        else
          sum += i.value[1]
        end
      end
    end
    sum
  end

  def hand_show
    n = 0
    for i in @cards
      n += 1
      puts "Card # #{n}: #{i.name.capitalize} of #{i.suite.capitalize} - #{i.value}"
    end
    puts "Total Value: #{hand_value}"
  end




end


 class Game
   attr_accessor :current_deck, :player_hand, :dealer_hand, :bet, :earns

   def initialize
     @current_deck = Deck.new
     @player_hand  = Hand.new
     @dealer_hand  = Hand.new
     @bet          = 0
     @earns        = 0

   end

   def get_player_card(number_of_cards)
    number_of_cards.times do
       player_hand.cards << current_deck.deal_card
     end
   end

   def get_dealer_card(number_of_cards)
    number_of_cards.times do
       dealer_hand.cards << current_deck.deal_card
     end
   end

   def player_actions(action, action2)

     if not action
       puts "(h)it, (st)and or (su)rrender your Hand"
       @action = gets.chomp.downcase
     elsif action
       @action = action
     end


     if (@action == "h" || @action == "st" || @action == "su") or
        (@action == 0   || @action == 1    || @action == 2)
       case

       when @action ==  "h" || @action == 0
         puts "\nHit"
         get_player_card(1)
         player_hand.hand_show
         stop = 0
         if player_hand.hand_value > 21
           puts "\nRESULT you lose! Bust! $ #{bet*-1}"
           total_earnings(bet*-1)
           finish_hand
           stop = 1
         end
         while player_hand.hand_value < 21 and stop == 0
           if not action2
             puts "(h)it or (st)and your Hand"
             @action2 = gets.chomp.downcase
           elsif action2
             @action2 = action2
           end

           case
           when @action2 == "h" || @action2 == 0
             puts "\nHit"
             get_player_card(1)
             player_hand.hand_show
             if player_hand.hand_value > 21
               puts "\nRESULT you lose! Bust! $ #{bet*-1}"
               total_earnings(bet*-1)
               finish_hand
               stop = 1
             end
           when @action2 == "st" || @action2 == 1
             puts "Stand, no more cards"
             stop = 1
           end
         end
       when @action == "st" || @action == 1
         puts "\nStand, no more cards"
       when @action == "su" || @action == 2
         puts "\nSurrendered, not playing this hand"
         total_earnings(bet*-0.5)
         finish_hand
       end

      else
        puts "Set the correct Action"
      end

    end

    def play_hand(times)
      @times = times
      n = 0

      while @times > 0

        puts "\n_____________________________________"
        puts "Hand #{n+1}"

        puts "\nPlace you bet in USD $ integer"
        player_bet(nil)

        puts "\nPlayer:"
        get_player_card(2)
        player_hand.hand_show

        puts "\nDealer:"
        get_dealer_card(1)
        dealer_hand.hand_show

        puts "\nPlayer turn:"
        player_actions(nil,nil)

        if player_hand.cards.size >= 2 and dealer_hand.cards.size >= 1
          evaluate
        end
        puts "Total game balance USD $: #{earns}"
        @times -= 1
        n += 1
      end
    end

    def bonus(veces)
      @times2 = veces
      n = 0

      while @times2 > 0

        puts "\n_____________________________________"
        puts "Hand #{n+1}"

        puts "\nPlace you bet in USD $ integer:"
        puts "US$ #{player_bet(100)}"

        puts "\nPlayer:"
        get_player_card(2)
        player_hand.hand_show

        puts "\nDealer:"
        get_dealer_card(1)
        dealer_hand.hand_show

        puts "\nPlayer turn:"
        player_actions(rand(0..2),rand(0..1))

        if player_hand.cards.size >= 2 and dealer_hand.cards.size >= 1
          evaluate
        end
        puts "Total game balance USD $: #{earns}"
        @times2 -= 1
        n += 1
      end
    end



    def evaluate
      puts "\nDealer turn:"
      get_dealer_card(1)

      while dealer_hand.hand_value < 17
        get_dealer_card(1)
      end

      dealer_hand.hand_show

      if player_hand.cards.size >= 2 and dealer_hand.cards.size >= 2
        case
        when dealer_hand.hand_value > 21
          puts "\nRESULT you win!, house bust! #{dealer_hand.hand_value} $ #{bet*1}"
          total_earnings(bet*1)
          finish_hand
        when dealer_hand.hand_value <= 21


          if player_hand.hand_value == dealer_hand.hand_value
            puts "\nRESULT you lose! Tide, House Win! #{player_hand.hand_value} $ #{bet*-1}"
            total_earnings(bet*-1)
            finish_hand

          elsif player_hand.hand_value < dealer_hand.hand_value
            puts "\nRESULT you lose! Dealer hand #{dealer_hand.hand_value}, your hand #{player_hand.hand_value} $ #{bet*-1}"
            total_earnings(bet*-1)
            finish_hand

          elsif player_hand.hand_value > dealer_hand.hand_value and player_hand.hand_value == 21
            puts "\nRESULT you win! Black Jack! Your hand #{player_hand.hand_value}, Dealer hand #{dealer_hand.hand_value} $ #{bet*1.5}"
            total_earnings(bet*1.5)
            finish_hand
          elsif player_hand.hand_value > dealer_hand.hand_value
            puts "\nRESULT you win! Your hand #{player_hand.hand_value}, Dealer hand #{dealer_hand.hand_value} $ #{bet*1}"
            total_earnings(bet*1)
            finish_hand
          end

        end
      else
        puts "Still nead to deal cards"
      end
    end


    def player_bet(bet)

      if not bet
        puts "Bet on this hand:"
        @bet = gets.chomp.to_i
      elsif bet
        @bet = bet
      end
      @bet
    end

    def total_earnings(earn)
      @earns = @earns + earn
    end

    def finish_hand
      player_hand.cards.clear
      dealer_hand.cards.clear
      if current_deck.playable_cards.size < 8
         current_deck.playable_cards.clear
         puts "\nNew Deck"
         @current_deck = Deck.new
      end
    end

  end




game = Game.new
game.bonus(30)



















require 'test/unit'

class CardTest < Test::Unit::TestCase
  def setup
    @card = Card.new(:hearts, :ten, 10)
  end

  def test_card_suite_is_correct
    assert_equal @card.suite, :hearts
  end

  def test_card_name_is_correct
    assert_equal @card.name, :ten
  end
  def test_card_value_is_correct
    assert_equal @card.value, 10
  end
end

class DeckTest < Test::Unit::TestCase
  def setup
    @deck = Deck.new
  end

  def test_new_deck_has_52_playable_cards
    assert_equal @deck.playable_cards.size, 52
  end

  def test_dealt_card_should_not_be_included_in_playable_cards
    card = @deck.deal_card
    refute(@deck.playable_cards.include?(card), "Significa que no esta la carta en el deck")
  end

  def test_dealt_card_shold_not_be_included_in_playable_cards_2
    card = @deck.deal_card
    assert_equal @deck.playable_cards.size, 51
  end


  def test_shuffled_deck_has_52_playable_cards
    @deck.shuffle
    assert_equal @deck.playable_cards.size, 52
  end
end


class GameTest < Test::Unit::TestCase
  def setup
    @game = Game.new
    @game.get_player_card(2)
    @game.get_dealer_card(2)
  end

  def test_if_player_hand_has_two_cards
    assert_equal @game.player_hand.cards.size, 2
  end

  def test_if_dealer_hand_has_two_cards
    assert_equal @game.dealer_hand.cards.size, 2
  end

  def test_if_deck_has_48_cards
    assert_equal @game.current_deck.playable_cards.size, 48
  end

end
