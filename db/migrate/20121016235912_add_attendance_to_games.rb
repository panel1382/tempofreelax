class AddAttendanceToGames < ActiveRecord::Migration
  def change
    add_column :Games, :attendance, :integer
  end
end
