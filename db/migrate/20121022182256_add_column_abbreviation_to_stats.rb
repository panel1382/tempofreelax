class AddColumnAbbreviationToStats < ActiveRecord::Migration
  def change
    add_column :stats, :abbreviation, :string
  end
end
