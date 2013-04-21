class Team < ActiveRecord::Base
  has_many :annual_stats
  has_many :national_ranks
  has_many :games
  has_many :game_stats
  has_many :players
  has_many :player_annual_stats
  belongs_to :conference
  attr_accessible :conference_id, :home_field, :name, :id
  
  def self.there?(name)
    team = Team.find_by_name(name)
    if team.nil?
      team = Team.new :name => name
      team.save      
    end
    team
  end
  
  def schedule(year)
    g = Game.schedule(id, year)
    s =[]
    g.each do |game|
      #home = {:us => :home, :them => :away, :home => true, :game => game}
      #away = {:us => :away, :them => :home, :home => false, :game => game }
      #game.home?(id) ? s.push(home) : s.push(away)
      s.push game
    end
  end
  
  def players_by_year(y)
   pgs = PlayerAnnualStat.where(:team_id => id, :year => (Date.new(y,1,1)..Date.new(y,12,31)))
   
   players = {
    :goalies => [],
    :attack => [],
    :defense => [],
    :fo => []
   }
   pgs.each do |stat|
    if stat.position == "Goalie"
      players[:goalies].push stat
    elsif stat.position == "Attack"
      players[:attack].push stat
    else
      players[:defense].push stat
    end

    players[:fo].push stat if stat.faceoff_specialist
    
   end
   players
  end
  
  def available_years
    years = [] 
    AnnualStat.where(:team_id => id).select(:year).each {|y| years.push y.year}
    
    years
  end
  
  def annual_stat_by_year(y)
    methods
    as =[]
    annual_stats.each do |s|
      as.push s if s.year.year == y
    end
    as[0]
  end
end
