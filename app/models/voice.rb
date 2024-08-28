require 'pry'

class Voice
  def self.start(game)

    message = "Welcome to the Vonage rock, paper, scissors swag game! Please reply with rock, paper, or scissors."

    response = Vonage.voice.create(
      to: [{
        type: 'phone',
        number: game.player.phone_number
      }],
      from: {
        type: 'phone',
        number: ENV['VONAGE_NUMBER']
      },
      ncco: [
        {
          action: "talk", text: message
        },
        {
          action: "input",
          type: ["speech"],
          speech: {
            context: ["rock", "paper", "scissors"]
          }
        }
      ]
    )

    game.status = 'started'
    game.channel_id = response.conversation_uuid
    game.save!
  end

  def self.process_input(game, params)
    input = params['speech']['results'][0]['text'].downcase

    case game.status
    when 'started', 'draw'
      if input_valid?(input)
        game.select_winner(input)
      else
        request_choice_again(game)
      end
    when 'second_input_attempt'
      if input_valid?(input)
        game.select_winner(input)
      else
        input_error(game)
      end
    when 'won', 'lost'
      announce_winner(game, game.computer_choice, input)
    else
      game_over(game)
    end
  end

  def self.input_valid?(input)
    ['rock', 'paper', 'scissors'].include?(input)
  end

  def self.request_choice_again(game)
    game.status = 'second_input_attempt'
    game.save!

    message = "I'm sorry, that was an invalid choice. Please reply with rock, paper, or scissors."

    ncco = [
      { action: "talk", text: message }
    ]

    ncco.to_json
  end

  def self.input_error(game)
    game.status = 'input_error'
    game.save!

    message = "I'm sorry, I still don't recognise your choice and so am unable to continue with the game. You can play rock, paper, scissors with the staff at the Vonage booth to try and win some swag!"

    ncco = [
      { action: "talk", text: message }
    ]

    ncco.to_json
  end

  def self.game_over(game)
    message = "The game is over. You can visit the Vonage booth to claim your swag if you won, or to grab some stickers and find out all about Vonage communications APIs"

    ncco = [
      { action: "talk", text: message }
    ]

    ncco.to_json
  end

  def self.announce_winner(game, computer_choice, input)
    message_text = "You chose #{input}, #{game.opponent} chose #{computer_choice}. You #{game.status}!"
    

    if game.status == 'won'
      message_text += " You can visit the Vonage booth to claim your swag and find out all about Vonage communication APIs!"
    else
      message_text += " Sorry you didn't win any swag, but you can still visit the Vonage booth to grab some stickers and find out all about Vonage communication APIs!"
    end

    ncco = [
      { action: "talk", text: message_text }
    ]

    ncco.to_json
  end

  def self.announce_draw(game, computer_choice, input)
    message = "You chose #{input}, #{game.opponent} chose #{computer_choice}. It's a draw! Please choose again. Reply with rock, paper, or scissors."

    ncco = [
      { action: "talk", text: message }
    ]

    ncco.to_json
  end
end