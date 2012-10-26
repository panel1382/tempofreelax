class CreateStats < ActiveRecord::Migration
  def change
    create_table :stats do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
