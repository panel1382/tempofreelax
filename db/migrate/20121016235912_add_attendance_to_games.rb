class AddAttendanceToGames < ActiveRecord::Migration
  def change
    add_column :games, :attendance, :integer
  end
end
