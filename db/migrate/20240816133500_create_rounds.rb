class CreateRounds < ActiveRecord::Migration[7.1]
  def change
    create_table :rounds do |t|
      t.string :result
      t.belongs_to :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
