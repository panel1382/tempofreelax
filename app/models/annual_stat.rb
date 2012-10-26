class AnnualStat < ActiveRecord::Base
  @exponent = 3.1
  
  belongs_to :team
  has_many :national_ranks
  
attr_accessible :assists, :clear_attempts, :clear_success, :conference_id, :def_adj, :extra_man_goals, :extra_man_opportunities, :faceoffs_won, :games, :goals, :man_down_goals, :off_adj, :opp_assists, :opp_clear_attempts, :opp_clear_success, :opp_extra_man_goals, :opp_extra_man_opportunities, :opp_faceoffs_won, :opp_goals, :opp_man_down_goals, :opp_shot_attempts, :opp_shots_on_goal, :rank_id, :shot_attempts, :shots_on_goal, :team_id, :wins, :year, :penalties, :opp_penalties, :ground_balls, :opp_ground_balls, :turnovers, :opp_turnovers, :caused_turnovers, :opp_caused_turnovers, :faceoffs_taken, :penalty_time, :opp_penalty_time
 
  def self.sum_all(year)
    start = Date.new(year,1,1)
    finish = Date.new(year,12,31)
    a = Game.where(:date => start..finish).select('home_team').uniq
    
    a.each_with_index do |team, i|
      stat = AnnualStat.where(:team_id => team.home_team, :year => stat).first
      stat = AnnualStat.new(:team_id => team.home_team, :year => start) if !stat.is_a?( AnnualStat )
      stat.sum
    end
  end
  
  def self.rank_all(year)
    start = Date.new(year,1,1)
    finish = Date.new(year,12,31)
    stats = Stat.all
    annuals = AnnualStat.where(:year => start..finish).all
    
    annuals.each do |a|
      stats.each {|s| a.rank(s.slug.to_sym) }
    end
  end
  
  def ranks
    if @ranks.nil?
      @ranks = {}
      national_ranks.each {|s| @ranks[s.stat.slug.to_sym] = s.rank if s.conference == false}
    end
    @ranks
  end
  
  def rank_all
    Stat.all.each{|s| rank s.slug.to_sym }
  end
  
  def rank(stat)
    puts methods.include? stat
    if methods.include? stat
      
      s = Stat.find_or_create_by_slug(stat.to_s)
      rank = NationalRank.where( :year => year.year, :stat_id => s.id, :team_id => team.id, :conference => false ).first
      
      if rank.nil?
        rank = national_ranks.build
        rank.team_id = team.id
        rank.stat_id = s.id
        rank.year = year.year  
        rank.conference = false
      end
    
      all = AnnualStat.find_all_by_year year
      list = []
      all.each do |row|
        list.push  row.send stat
      end
      
      list.sort!
      list.reverse! if s.order == 'descending'
      rank.rank = list.index( send(stat) ) + 1
      
      rank.save
      puts rank.id     
    end
  end
  
  def sum
    home_games = Game.where(:home_team => team_id)
    away_games = Game.where(:away_team => team_id)
    us = actual_hash
    them = opp_hash
    actual = []
    opp = []
    
    home_games.each do |game|
      actual.push(game.home)
      opp.push(game.away)
      us[:wins]+= 1 if game.home.goals > game.away.goals
    end
    away_games.each do |game|
      actual.push game.away
      opp.push game.home
      us[:wins]+= 1 if game.home.goals < game.away.goals
    end
    
    actual.each do |game|
      us[:games]+=1
      temp = actual_hash
      keys_for_sum.each {|k| temp[k]= game.send k}
      us.merge(temp){|key, old, new| us[key]= old+new}
    end
    
    opp.each do |game|
      temp = opp_hash
      keys_for_sum.each {|k| temp[('opp_'+k.to_s).to_sym] = game.send k}
      them.merge(temp){|key, old, new| them[key]= old+new}
    end
    
    total = us.merge them
    update_attributes(total)
  end
  
  #various stats
  def losses
    games - wins
  end
  
  def possessions
    faceoffs_won + clear_attempts + (opp_clear_attempts - opp_clear_success)
  end
  
  def opp_possessions
    opp_faceoffs_won + opp_clear_attempts + (clear_attempts - clear_success)
  end
  
  def pace
    (possessions + opp_possessions).to_f / games
  end
  
  def pos_percentage
    possessions.to_f / (possessions + opp_possessions) * 100
  end
  
  def opp_pos_percentage
    100 - pos_percentage
  end
  
  def faceoffs_taken
    faceoffs_won + opp_faceoffs_won
  end
  
  def faceoff_percentage
    faceoffs_won.to_f / faceoffs_taken * 100
  end
  
  def shooting_percentage
    goals.to_f / shot_attempts  * 100
  end
  
  def effective_shooting_percentage
    goals.to_f / shots_on_goal * 100
  end
  
  def opp_shooting_percentage
    opp_goals.to_f / opp_shot_attempts * 100
  end
  
  def opp_effective_shooting_percentage
    opp_goals.to_f / opp_shots_on_goal * 100
  end
  
  def shot_accuracy
    shots_on_goal / shot_attempts
  end
  
  def opp_shot_accuracy
    opp_shots_on_goal / opp_shot_attempts
  end
  
  def offensive_clear_rate
    clear_success.to_f / clear_attempts * 100
  end
  
  def defensive_clear_rate
    (opp_clear_success.to_f / opp_clear_attempts) * 100
  end
  
  def offensive_efficiency
    (goals.to_f / possessions) * 100
  end
  
  def defensive_efficiency
    (opp_goals.to_f / opp_possessions) * 100
  end
  
  def extra_man_conversion
    extra_man_goals.to_f / extra_man_opportunities * 100
  end
  
  def man_down_defense
    (1 - (opp_extra_man_goals.to_f / opp_extra_man_opportunities)) * 100
  end
  
  def save_percentage
    (1 - (opp_goals.to_f / opp_shots_on_goal)) * 100 
  end
  
  def saves
    opp_shots_on_goal - opp_goals
  end
  
  def adjusted_offensive_efficiency
    ((goals.to_f / possessions) / off_adj) * 100
  end
  
  def adjusted_defensive_efficiency
    ((opp_goals.to_f / opp_possessions) / def_adj) * 100
  end
  
  def pyth
      (1 / (1 + (((adjusted_defensive_efficiency * opp_pos_percentage) / (adjusted_offensive_efficiency * pos_percentage))**3.1))) * 100
  end
  
  def assists_per_goal
    assists.to_f / goals
  end
  
  def opp_assists_per_goal
    opp_assists.to_f / opp_goals
  end
  
  #possessions per game
  def ppg
    (possessions.to_f)/games
  end
  
  #opponent possessions per game
  def oppg
    (opp_possessions.to_f)/games
  end
  
  #goals per possession 
  def gpp
    (goals.to_f) / possessions
  end
  
  def goal_diff
    goals - opp_goals
  end
  
  def actual_hash
    {
    :games => 0,
    :wins => 0,
    :goals => 0,
    :shot_attempts => 0,
    :shots_on_goal => 0,
    :assists => 0,
    :faceoffs_won => 0,
    :faceoffs_taken => 0,
    :clear_attempts => 0,
    :clear_success => 0,
    :extra_man_opportunities => 0,
    :extra_man_goals => 0 ,
    :ground_balls => 0,
    :turnovers => 0,
    :caused_turnovers => 0,
    :penalty_time => 0,
    :man_down_goals => 0,
    :penalties => 0
    }
  end
  def keys_for_sum
      [ :goals, :shot_attempts, :shots_on_goal, :assists,:faceoffs_won,:faceoffs_taken, :clear_attempts, 
        :clear_success, :extra_man_opportunities, :extra_man_goals , :ground_balls, :turnovers, 
        :caused_turnovers, :penalty_time, :man_down_goals, :penalties ]
      
  end  
  def opp_hash
    {
    :opp_goals => 0,
    :opp_shot_attempts => 0,
    :opp_shots_on_goal => 0,
    :opp_assists => 0,
    :opp_faceoffs_won => 0,
    :opp_clear_attempts => 0,
    :opp_clear_success => 0,
    :opp_extra_man_opportunities => 0,
    :opp_extra_man_goals => 0,
    :opp_ground_balls => 0,
    :opp_turnovers => 0,
    :opp_caused_turnovers => 0,
    :opp_penalty_time => 0,
    :opp_man_down_goals => 0,
    :opp_penalties => 0
    }
  end
  
  
end

