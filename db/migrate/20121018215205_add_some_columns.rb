class AddSomeColumns < ActiveRecord::Migration
  def change
    #add game id to game
    add_column :games, :ncaa_id, :string
    
    #add GB, TO, CT, #penatly_time
    add_column :game_stats, :ground_balls, :integer
    add_column :game_stats, :turnovers, :integer
    add_column :game_stats, :caused_turnovers, :integer
    add_column :game_stats, :penalty_time, :integer
    
    add_column :annual_stats, :ground_balls, :integer
    add_column :annual_stats, :turnovers, :integer
    add_column :annual_stats, :caused_turnovers, :integer
    add_column :annual_stats, :penalty_time, :integer
    
    add_column :annual_stats, :opp_ground_balls, :integer
    add_column :annual_stats, :opp_turnovers, :integer
    add_column :annual_stats, :opp_caused_turnovers, :integer
    add_column :annual_stats, :opp_penalty_time, :integer
  end
end
