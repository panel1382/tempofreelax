class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :team_name
      t.integer :conference_id
      t.string :home_field

      t.timestamps
    end
  end
end
