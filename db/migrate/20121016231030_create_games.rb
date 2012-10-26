class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :home_team
      t.integer :away_team
      t.date :year
      t.string :venue
      t.date :date

      t.timestamps
    end
  end
end
