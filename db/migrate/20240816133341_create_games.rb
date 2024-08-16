class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.string :status
      t.string :opponent
      t.string :channel
      t.string :swag_status
      t.belongs_to :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
