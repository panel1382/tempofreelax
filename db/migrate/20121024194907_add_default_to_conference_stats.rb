class AddDefaultToConferenceStats < ActiveRecord::Migration
  def change
    change_column_default :conference_stats, :def_adj, 1
    change_column_default :conference_stats, :off_adj, 1
  end
end
