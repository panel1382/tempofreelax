class AnnualStat < ActiveRecord::Base
  @exponent = 3.1
  
  belongs_to :team
  has_many :national_ranks
  
attr_accessible :assists, :clear_attempts, :clear_success, :conference_id, :def_adj, :extra_man_goals, :extra_man_opportunities, :faceoffs_won, :games, :goals, :man_down_goals, :off_adj, :opp_assists, :opp_clear_attempts, :opp_clear_success, :opp_extra_man_goals, :opp_extra_man_opportunities, :opp_faceoffs_won, :opp_goals, :opp_man_down_goals, :opp_shot_attempts, :opp_shots_on_goal, :rank_id, :shot_attempts, :shots_on_goal, :team_id, :wins, :year, :penalties, :opp_penalties, :ground_balls, :opp_ground_balls, :turnovers, :opp_turnovers, :caused_turnovers, :opp_caused_turnovers, :faceoffs_taken, :penalty_time, :opp_penalty_time, :opp_pyth
 
  def self.sum_all(year)
    start = Date.new(year,1,1)
    finish = Date.new(year,12,31)
    a = AnnualStat.where(:date => start..finish).select(:team_id).uniq
    
    a.each_with_index do |team, i|
      stat = AnnualStat.where(:team_id => team.home_team, :year => start).first
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
  
  def self.find_or_create(team_id, year)
    require 'date'
    start = Date.new(year,1,1)
    finish = Date.new(year,12,31)
    as = AnnualStat.where(:team_id => team_id, :year => start..finish).first
    if as.nil?
      hash = AnnualStat.initHash
      hash[:off_adj] = 1.0
      hash[:def_adj] = 1.0
      hash[:team_id] = team_id
      hash[:year] = Date.new(year,1,1)
      hash[:opp_pyth] = 50
      as = AnnualStat.new(hash)
      as.save
    end
    puts as.id
    as
  end
  
  def self.national_avg(year)
    require 'date'
    #find all annual stats for the given year
    start = Date.new(year,1,1)
    finish = Date.new(year,12,31)
    stats = AnnualStat.where(:year => start..finish).all
    
    #set up variables for averages
    n = stats.length
    avg = 0.0
    
    #sum it up and divide
    stats.each { |stat| avg += stat.offensive_efficiency }
    avg/n
  end
  
  def self.available_years
    require 'date'
    range = Date.new(2000,01,01)..Date.today
    years = AnnualStat.where(:year => range ).select('year').uniq
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
        n = row.send stat
        list.push(n) if !n.nil? 
      end
      
      if list.length > 0
        list.sort!
        list.reverse! if s.order == 'descending'
        i = list.index( send(stat) )
        rank.rank = i + 1 if !i.nil?
      end
      
      rank.save    
    end
  end
  
  def sum 
    require 'date'
    home_games = Game.where(:home_team => team_id, :date => year..Date.new(year.year, 12, 31))
    away_games = Game.where(:away_team => team_id, :date => year..Date.new(year.year, 12, 31))
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
      us.merge(temp) do |key, old, new|
        us[key]= old.to_i+new.to_i
      end
    end
    
    opp.each do |game|
      temp = opp_hash
      keys_for_sum.each {|k| temp[('opp_'+k.to_s).to_sym] = game.send k}
      them.merge(temp) do |key, old, new|
        them[key]= old.to_i+new.to_i
      end
    end
    
    total = us.merge them
    update_attributes(total)
    calculate_adjust
  end
  
  def calculate_adjust
    national = AnnualStat.national_avg(year.year)
    opps = opponent_stats
    n = opps.length
    offense = 0.0
    defense = 0.0
    all_pyth = 0.0
    puts "#{team.name}: #{n}"
    opps.each do |opp|
      if !opp.nil?
        offense += opp.offensive_efficiency
        defense += opp.defensive_efficiency
        all_pyth += opp.pyth
      else
        puts opp.inspect
        n -= 1
      end
    end
    if n > 0
      def_adj = (offense/n) / national
      off_adj = (defense/n) / national
      opp_pyth = all_pyth / n
    else
      def_adj = 1.0
      off_adj = 1.0
    end
    
    update_attributes :off_adj => off_adj, :def_adj => def_adj, :opp_pyth => opp_pyth
  end
  
  def game_list
    require 'date'
    home_games = Game.where(:home_team => team_id, :date => year..Date.new(year.year, 12, 31))
    away_games = Game.where(:away_team => team_id, :date => year..Date.new(year.year, 12, 31))
    
    games = {:home => home_games, :away => away_games}
  end
  
  def opponent_stats
    opp = []
    g = game_list
    g[:home].each {|game| opp.push AnnualStat.where(:team_id => game.away_team, :year => year).first} 
    g[:away].each {|game| opp.push AnnualStat.where(:team_id => game.home_team, :year => year).first}
    opp
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
  
  def shots_per_possession
    shots_on_goal.to_f / possessions
  end
  
  def opp_shots_per_possession
    opp_shots_on_goal.to_f / opp_possessions
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
  
  def extra_man_per_possession
    extra_man_opportunities.to_f / possessions
  end
  
  def opp_extra_man_per_possession
    opp_extra_man_opportunities.to_f / opp_possessions
  end
  
  def extra_man_conversion
    extra_man_goals.to_f / extra_man_opportunities * 100
  end
  
  def man_down_defense
    (1 - (opp_extra_man_goals.to_f / opp_extra_man_opportunities)) * 100
  end
  
  def emo_reliance
    (extra_man_goals.to_f / goals) * 100
  end
  
  def opp_emo_reliance
    (opp_extra_man_goals.to_f / opp_goals) * 100
  end
  
  def save_percentage
    (1 - (opp_goals.to_f / opp_shots_on_goal)) * 100 
  end
  
  def saves_per_possession
    saves.to_f / opp_possessions
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
  
  def assists_per_possession
    assists.to_f / goals
  end
  
  def opp_assists_per_possession
    opp_assists.to_f / opp_goals
  end
  
  def turnovers_per_possession
    turnovers.to_f / possessions
  end
  
  def opp_turnovers_per_possession
    opp_turnovers.to_f / opp_possessions
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
  
  def self.initHash
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
    :penalties => 0,
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
    :opp_penalties => 0,
    :off_adj => 1.0,
    :def_adj => 1.0,
    :opp_pyth => 50.0
    }
  end
  
  
end

