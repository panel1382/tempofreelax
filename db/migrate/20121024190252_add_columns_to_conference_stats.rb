class AddColumnsToConferenceStats < ActiveRecord::Migration
  def change
    add_column :conference_stats, :faceoffs_taken, :integer
    add_column :conference_stats, :penalty_time, :integer
    add_column :conference_stats, :penalties, :integer
    add_column :conference_stats, :opp_penalty_time, :integer
    add_column :conference_stats, :opp_penalties, :integer
  end
end