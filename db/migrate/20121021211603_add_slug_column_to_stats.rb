class AddSlugColumnToStats < ActiveRecord::Migration
  def change
    add_column :stats, :slug, :string
  end
end
