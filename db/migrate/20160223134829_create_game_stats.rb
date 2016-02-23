class CreateGameStats < ActiveRecord::Migration
  def change
    create_table :game_stats do |t|
      t.integer :game_id
      t.integer :player_score
      t.integer :dealer_score

      t.timestamps null: false
    end
  end
end
