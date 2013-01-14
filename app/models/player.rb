class Player < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :team_id
  belongs_to :team
  has_many :player_game_stats
  
  def self.there?(data)
    p = Player.where(data).first
    if p.nil? then p = Player.new(data); p.save! end
    p
  end
end
