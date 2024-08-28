class Game < ApplicationRecord
  belongs_to :player

  CHOICES = {
    rock: { beats: 'scissors' },
    paper: { beats: 'rock' },
    scissors: { beats: 'paper' }
  }

  def select_winner(input)
    computer_choice = %w[rock paper scissors].sample
    self.computer_choice = computer_choice

    if input == computer_choice
      self.status = 'draw'
      self.save!
      self.interface.announce_draw(game, computer_choice, input)
    elsif CHOICES[input.to_sym][:beats] == computer_choice
      self.status = 'won'
      self.swag_status = 'to be claimed'
      self.save!
      self.interface.announce_winner(self, computer_choice, input)
    else
      self.status = 'lost'
      self.save!
      self.interface.announce_winner(self, computer_choice, input)
    end
  end

  def interface
    channel.capitalize.constantize
  end
end
