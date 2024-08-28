class AddComputerChoiceToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :computer_choice, :string
  end
end
