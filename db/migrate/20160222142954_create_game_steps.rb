class CreateGameSteps < ActiveRecord::Migration
  def change
    create_table :game_steps do |t|
      t.integer :game_id
      t.datetime :played_at
      t.text :cards_dealt_to_player
      t.text :cards_dealt_to_dealer
      t.integer :move_type

      t.timestamps null: false
    end
  end
end
