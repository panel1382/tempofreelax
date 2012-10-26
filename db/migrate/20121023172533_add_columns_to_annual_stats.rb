class AddColumnsToAnnualStats < ActiveRecord::Migration
  def change
    add_column :annual_stats, :faceoffs_taken, :integer
  end
end
