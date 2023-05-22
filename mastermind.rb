class Mastermind
  COLORS = %w[red green blue yellow].freeze
  CODE_LENGTH = 4
  MAX_ATTEMPTS = 10

  def initialize
    @secret_code = []
    @guesses = []
    @role = nil
    @attempts = 0
  end

  def play
    puts "Welcome to Mastermind!"
    choose_role
    generate_secret_code if code_creator?
    loop do
      break if game_over?

      puts "Attempt #{attempt_number}:"
      guess = code_guesser? ? get_guess : generate_guess
      feedback = evaluate_guess(guess)
      display_feedback(feedback)
      @guesses << guess
      @attempts += 1
    end
    puts "You #{game_won? ? 'won' : 'lost'}! The secret code was: #{@secret_code}"
  end

  private

  def choose_role
    loop do
      puts "Do you want to be the (c)ode creator or the (g)uesser?"
      choice = gets.chomp.downcase
      if %w[c g].include?(choice)
        @role = choice
        break
      else
        puts "Invalid choice. Please enter 'c' or 'g'."
      end
    end
  end

  def code_creator?
    @role == 'c'
  end

  def code_guesser?
    @role == 'g'
  end

  def generate_secret_code
    puts "Enter the secret code (e.g., 'red green blue yellow'):"
    loop do
      code = gets.chomp.split
      if valid_code?(code)
        @secret_code = code
        break
      else
        puts "Invalid code. Please enter #{CODE_LENGTH} colors separated by spaces."
      end
    end
  end

  def valid_code?(code)
    code.length == CODE_LENGTH && code.all? { |color| COLORS.include?(color) }
  end

  def generate_guess
    Array.new(CODE_LENGTH) { COLORS.sample }
  end

  def game_over?
    game_won? || @attempts >= MAX_ATTEMPTS
  end

  def game_won?
    @guesses.last == @secret_code
  end

  def attempt_number
    @attempts + 1
  end

  def get_guess
    print "Enter your guess (e.g., 'red green blue yellow'): "
    loop do
      guess = gets.chomp.split
      return guess if valid_guess?(guess)

      puts "Invalid guess. Please enter #{CODE_LENGTH} colors separated by spaces."
    end
  end

  def valid_guess?(guess)
    guess.length == CODE_LENGTH && guess.all? { |color| COLORS.include?(color) }
  end

  def evaluate_guess(guess)
    feedback = { black: 0, white: 0 }
    secret_code_counts = Hash.new(0)
    remaining_guesses = []

    guess.each_with_index do |color, index|
      if color == @secret_code[index]
        feedback[:black] += 1
      else
        secret_code_counts[@secret_code[index]] += 1
        remaining_guesses << color
      end
    end

    remaining_guesses.each do |color|
      next unless secret_code_counts[color].positive?

      feedback[:white] += 1
      secret_code_counts[color] -= 1
    end

    feedback
  end

  def display_feedback(feedback)
    puts "Black pegs: #{feedback[:black]}, White pegs: #{feedback[:white]}"
  end
end

# Start the game
game = Mastermind.new
game.play