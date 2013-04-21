class PlayerAnnualStat < ActiveRecord::Base
  require 'date'
  attr_accessible :assists, :caused_turnovers, :extra_man_goals, :faceoffs_won, :faceoffs_taken, :game_id, :goalie_seconds, :goals, :goals_allowed, :ground_balls, :losses, :man_down_goals, :penalties, :penalty_time, :player_id, :saves, :shot_attempts, :shots_on_goal, :team_id, :ties, :turnovers, :wins, :year, :possessions, :opp_possessions, :position, :faceoff_specialist
  
  belongs_to :player
  belongs_to :team
  has_many :player_game_stats
  
  @@defender_ratio = 3
  @@goalie_threshold = 600
  @@faceoff_threshold = 20
  @@pri_attack_constants = [1.0,0.8,1.0,0.2]
  @@pri_midfield_constants = [1.5,0.9,0.7,0.2,0.05]
  @@pri_defense_constants = [2.0,1.3,1.0,0.5,0.05]
  @@pri_goalie_constants = [4.0,2.5,0.5,0.5,1.5]
  
  
  def self.sumAll(year)
    range = Date.new(year,1,1)..Date.new(year,12,31)
    
    pgs = PlayerGameStat.joins(:player, :game).where('games.date' => range).select(:player_id).uniq
    pgs.each do |t|
      if t.player.team_id != 65
        begin
          stat = PlayerAnnualStat.find_or_create_by_player_id_and_year(:player_id => t.player_id, :year => Date.new(year,1,1))
          stat.sum
          puts t.player_id
        rescue Exception => e
          puts "Unable to sum for player: #{t.player.id}\n#{e.inspect}"
        end
      end
    end
  end
  
  def games
    if @games.nil?
      pgs = PlayerGameStat.joins(:player, :game).where('games.date' => Date.new(year.year,1,1)..Date.new(year.year,12,31), :player_id => player_id).select(:player_id)
      @games = pgs.length
    else
      @games
    end
  end
  
  def team_stats
    team.annual_stat_by_year year.year
  end
  
  def keys_for_sum
    [:assists, :caused_turnovers, :extra_man_goals, :faceoffs_won, :faceoffs_taken, 
    :goalie_seconds, :goals, :goals_allowed, :ground_balls, :losses, :man_down_goals, 
    :penalties, :penalty_time, :saves, :shot_attempts, :shots_on_goal, :ties, 
    :turnovers, :wins, :possessions, :opp_possessions]
  end
  
  def empty_hash
    h={}
    keys_for_sum.each {|key| h[key] = 0}
    h
  end
  
  def guess_position
#    if goalie_seconds > @@goalie_threshold
#      self.position = "Goalie"
#    elsif (ground_balls.to_f / shot_attempts) > @@defender_ratio
#      self.position = "Defense"
#    else
#      self.position = "Attack"
#    end
    #pri guessing
    pris = [pri_attack, pri_midfield, pri_defense, pri_goalie]
    puts pris.inspect
    thing = pris.sort.reverse!

    case thing[0]
    when pri_attack
      self.position = "Attack"
    when pri_midfield
      self.position = "Midfield"
    when pri_defense
      self.position = "Defense"
    when pri_goalie
      self.position = "Goalie"
    else
      self.position = "uhhhhhhhhhh"
    end
    faceoffs_taken > @@faceoff_threshold ? self.faceoff_specialist = true : self.faceoff_specialist = false 
    save
    position
  end
  
  def sum
    range = (Date.new(year.year,1,1)..Date.new(year.year,12,31))
    games = PlayerGameStat.joins(:game).where(:player_id => player_id, 'games.date' => range)
    self.team_id = player.team_id
    hash = empty_hash
    games.each do |game|
      if game.game.home_team == team_id 
        us = :home 
        them = :away 
      else
        us = :away
        them = :home
      end
      keys_for_sum.each do |k|
        if k == :possessions
          hash[k] += game.game.possessions us
        elsif k == :opp_possessions
          hash[k] += game.game.possessions them
        else
          val = game.send k
          hash[k] += (game.send k) if !val.nil?
        end
      end
    end
    
    update_attributes hash
    guess_position
    save!
  end
  
  def active?
    if goals < 2 and assists < 2 and caused_turnovers < 5 and ground_balls < 10 and shot_attempts < 10
      false
    else
      true
    end
  end
  
  # stats
  def goals_per_possession
    (goals.to_f / possessions.to_i) 
  end
  
  def assists_per_possession
    (assists.to_f / possessions.to_i)
  end
  
  def turnovers_per_possession
    (turnovers.to_f / possessions.to_i)
  end
  
  def caused_turnovers_per_possession
    (caused_turnovers.to_f / opp_possessions.to_i)
  end
  
  def ground_balls_per_possession
    ground_balls.to_f / (possessions).to_i
  end
  
  def ground_balls_per_defensive_possession
    ground_balls.to_f / opp_possessions.to_i
  end
  
  def shots_per_possession
    shot_attempts.to_f / possessions.to_i
  end
  
  def shooting_percentage
    if shot_attempts.to_i > 0
      (shots_on_goal.to_f / shot_attempts)*100
    else
      0
    end
  end
  
  def goals_allowed_per_possesion
    goals_allowed.to_f / opp_possessions.to_i
  end
  
  def save_percentage
    (saves.to_f / (saves + goals_allowed))*100
  end
  
  def goalie_minutes
    minutes = (goalie_seconds.to_i / 60)
    seconds = goalie_seconds.to_i % 60
    "#{minutes}:#{seconds}"
  end
  
  def fo_percentage
    (faceoffs_won.to_f / faceoffs_taken.to_i)*100
  end
  
  def faceoffs_lost
    faceoffs_taken.to_i - faceoffs_won.to_i
  end 
  
  def turnovers_per_faceoff
    turnovers.to_f / faceoffs_taken.to_i
  end
  
  def shots_saved
    shots_on_goal - goals
  end
  
  #strength of schedule for pri
  def pri_sos
    team_stats.opp_pyth  / 50.0 
  end
  
  def pri_sog_percentage
    shots_saved.to_f / shot_attempts 
  end
  
  #for pri: goals/shots on goal
  def pri_goal_percentage
    shots_on_goal > 0 ? goals.to_f / shots_on_goal : 1.0
  end
  
  #for pri: team's average goals scored  per game / opponent's average goals allowed per game;
  def pri_toff
    team_stats.goals_per_game / team_stats.opp_avg_goals_per_game
  end
  
  #for pri: team's average goals allowed per game / opponent's average  goals scored per game;
  def pri_tdef
    team_stats.opp_goals_per_game / team_stats.opp_avg_goals_against_per_game
  end
  
  #for pri: team's clear percentage;
  def pri_tclear
    team_stats.offensive_clear_rate
  end
  
  def pri_attack
    a = (((goals*@@pri_attack_constants[0]*((pri_goal_percentage+pri_sog_percentage)/2)*(pri_toff)*pri_sos) / games) +
    ((assists*@@pri_attack_constants[1]*pri_toff*pri_sos) / games )  +
    ((ground_balls*@@pri_attack_constants[2]*pri_toff*pri_sos) / games) +
    (((5*caused_turnovers - turnovers)*@@pri_attack_constants[3]*pri_toff*pri_sos) / games)).round 3
    
    a = 0.0 if a.nan?
    a
  end
  
  def pri_midfield
    a = ((goals*@@pri_midfield_constants[0]*pri_goal_percentage*((pri_toff+pri_tdef)/2)*pri_sos) / games) +
    ((assists*@@pri_midfield_constants[1]*((pri_toff+pri_tdef)/2)*pri_sos) / games )  +
    ((ground_balls*@@pri_midfield_constants[2]*((pri_toff+pri_tdef)/2)*pri_sos) / games) +
    (((5*caused_turnovers - turnovers)*@@pri_midfield_constants[3]*((pri_toff+pri_tdef)/2)*pri_sos) / games)
    a += ((faceoffs_won * @@pri_midfield_constants[4] * (faceoffs_won / faceoffs_taken)*((pri_toff+pri_tdef)/2)*pri_sos) / games) if faceoffs_taken > 0
    a.round 3
  end
  
  def pri_defense
    if games > 0
      a = ((goals*@@pri_defense_constants[0]*pri_goal_percentage*(pri_toff)*pri_sos) / games) +
      ((assists*@@pri_defense_constants[1]*pri_toff*pri_sos) / games )  +
      ((ground_balls*@@pri_defense_constants[2]*pri_toff*pri_sos) / games) +
      (((5*caused_turnovers - turnovers)*@@pri_defense_constants[3]*pri_toff*pri_sos) / games)
      a += ((faceoffs_won * @@pri_defense_constants[4] * (faceoffs_won / faceoffs_taken)*pri_tdef*pri_sos) / games) if faceoffs_taken > 0
      a.round 3
    else
      "no games!!!!"
    end
  end
  
  def pri_goalie
    if goalie_seconds > 0
      a = ((goals*@@pri_goalie_constants[0]*pri_goal_percentage*(pri_toff)*pri_sos) / games) +
      ((assists*@@pri_goalie_constants[1]*pri_toff*pri_sos) / games )  +
      ((ground_balls*@@pri_goalie_constants[2]*pri_toff*pri_sos) / games) +
      (((5*caused_turnovers - turnovers)*@@pri_goalie_constants[3]*pri_toff*pri_sos) / games) +
      ((saves * @@pri_goalie_constants[4] * pri_tdef*pri_sos) / games)
      a.round 3
    else
      0.0
    end
  end
end
