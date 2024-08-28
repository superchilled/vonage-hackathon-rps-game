class AddChannelIdToGames < ActiveRecord::Migration[7.1]
  def change
    add_column :games, :channel_id, :string
  end
end
