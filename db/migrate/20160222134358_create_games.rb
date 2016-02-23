class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :bet_amount
      t.datetime :ended_at
      t.integer :state
      t.integer :winner
      t.text    :cards_dealt

      t.timestamps null: false
    end
  end
end
