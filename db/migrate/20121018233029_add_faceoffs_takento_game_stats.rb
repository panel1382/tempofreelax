class AddFaceoffsTakentoGameStats < ActiveRecord::Migration
  def change
    add_column :game_stats, :faceoffs_taken, :integer
    add_column :game_stats, :saves, :integer
  end
end
