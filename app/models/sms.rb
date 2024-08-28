require 'pry'

class Sms
  def self.start(game)
    message = Vonage.messaging.sms(
      message: "Welcome to the Vonage rock, paper, scissors swag game! Please reply with rock, paper, or scissors."
    )

    response = Vonage.messaging.send(
      to: game.player.phone_number,
      from: ENV['VONAGE_NUMBER'],
      **message
    )

    game.status = 'started'
    game.channel_id = game.player.phone_number
    game.save!
  end

  def self.process_input(game, params)
    input = params[:text].downcase

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
    message = Vonage.messaging.sms(
      message: "I'm sorry, that was an invalid choice. Please reply with rock, paper, or scissors."
    )

    response = Vonage.messaging.send(
      to: game.player.phone_number,
      from: ENV['VONAGE_NUMBER'],
      **message
    )

    game.status = 'second_input_attempt'
    game.save!
  end

  def self.input_error(game)
    message = Vonage.messaging.sms(
      message: "I'm sorry, I still don't recognise your choice and so am unable to continue with the game. You can play rock, paper, scissors with the staff at the Vonage booth to try and win some swag!"
    )

    response = Vonage.messaging.send(
      to: game.player.phone_number,
      from: ENV['VONAGE_NUMBER'],
      **message
    )

    game.status = 'input_error'
    game.save!
  end

  def self.game_over(game)
    message = Vonage.messaging.sms(
      message: "The game is over. You can visit the Vonage booth to claim your swag if you won, or to grab some stickers and find out all about Vonage communications APIs"
    )

    response = Vonage.messaging.send(
      to: game.player.phone_number,
      from: ENV['VONAGE_NUMBER'],
      **message
    )
  end

  def self.announce_winner(game, computer_choice, input)
    message_text = "You chose #{input}, #{game.opponent} chose #{computer_choice}. You #{game.status}!"
    

    if game.status == 'won'
      message_text += " You can visit the Vonage booth to claim your swag and find out all about Vonage communication APIs!"
    else
      message_text += " Sorry you didn't win any swag, but you can still visit the Vonage booth to grab some stickers and find out all about Vonage communication APIs!"
    end

    message = Vonage.messaging.sms(
      message: message_text
    )

    response = Vonage.messaging.send(
      to: game.player.phone_number,
      from: ENV['VONAGE_NUMBER'],
      **message
    )
  end

  def self.announce_draw(game, computer_choice, input)
    message = Vonage.messaging.sms(
      message: "You chose #{input}, #{game.opponent} chose #{computer_choice}. It's a draw! Please choose again. Reply with rock, paper, or scissors."
    )

    response = Vonage.messaging.send(
      to: game.player.phone_number,
      from: ENV['VONAGE_NUMBER'],
      **message
    )
  end
end