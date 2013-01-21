class AddColumnsToPlayerAnnualStats < ActiveRecord::Migration
  def change
    add_column :player_annual_stats, :position, :string
    add_column :player_annual_stats, :faceoff_specialist, :boolean
  end
end
