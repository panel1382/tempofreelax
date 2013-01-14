class CreateNationalRanks < ActiveRecord::Migration
  def change
    
    create_table :national_ranks do |t|
      t.integer :stat_id
      t.integer :team_id
      t.integer :annual_stat_id
      t.integer :year
      t.integer :rank

      t.timestamps
    end
  end
end
