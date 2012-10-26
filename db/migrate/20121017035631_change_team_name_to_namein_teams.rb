class ChangeTeamNameToNameinTeams < ActiveRecord::Migration
  def up
    remove_column :teams, :team_name
    add_column :teams, :name, :string
  end

  def down
    add_column :teams, :team_name, :string
    remove_column :teams, :name
  end
end
