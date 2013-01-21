class Player < ActiveRecord::Base
  attr_accessible :first_name, :last_name, :team_id
  belongs_to :team
  has_many :player_game_stats
  has_many :player_annual_stats
  
  def self.there?(data)
    p = Player.where(data).first
    if p.nil? then p = Player.new(data); p.save! end
    p
  end
  
  def self.all_players_by_year(y)
    PlayerGameStat.joins(:player, :game).where('games.date' => (Date.new(y,1,1)..Date.new(y,12,31))).select(:player_id).order('games.team_id').uniq
  end
  
  def game_stats_by_year(y)
    PlayerGameStat.joins(:game).where('games.date' => Date.new(y,1,1)..Date.new(y,12,31), :player_id => id)
  end
  
  def annual_stat_by_year(y)
    require 'date'
    year = Date.new(y,1,1)
    a=0
    player_annual_stats.each { |as| a = as if as.year == year }
    a
  end
end
