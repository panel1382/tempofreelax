class AddColumnToNationalRanks < ActiveRecord::Migration
  def change
    add_column :national_ranks, :conference, :boolean, :default => false
  end
end
