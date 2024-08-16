class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :name
      t.string :phone_number
      t.boolean :terms_and_conditions_accepted

      t.timestamps
    end
  end
end
