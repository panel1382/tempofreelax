class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :player_id
      t.integer :position_id

      t.timestamps
    end
  end
end
