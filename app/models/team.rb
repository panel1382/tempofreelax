class Team < ActiveRecord::Base
  has_many :annual_stats
  has_many :national_ranks
  has_many :games
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
    s
  end
end
