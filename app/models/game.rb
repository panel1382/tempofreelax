class Game < ActiveRecord::Base
  has_many :game_stats
  has_many :player_game_stats
  attr_accessible :away_team, :date, :home_team, :venue, :year, :attendance,:ncaa_id
  
  accepts_nested_attributes_for :game_stats
  def home
    if game_stats.length > 0
      if game_stats[0].home
        game_stats[0]
      else
        game_stats[1]
      end
    else
      nil
    end  
  end
  
  def away
    if game_stats.length > 0
      if game_stats[0].home
        game_stats[1]
      else
        game_stats[0]
      end
    else
      nil
    end   
  end
  
  def home?(team_id)
    home_team == team_id ? true : nil
  end
  
  def teams
    range = (Date.new(date.year,01,01)..Date.new(date.year,12,31))
  
    {
      :home => Team.find(home_team),
      :away => Team.find(away_team),
      :home_as => AnnualStat.where(:team_id => home_team, :year => range).first,
      :away_as => AnnualStat.where(:team_id => away_team, :year => range).first
    }
  end
  
  def prediction(us)
    t = self.teams
    #(AWin% - (BWin% * AWin%)) / (AWin% + BWin% - (2 * AWin% * BWin%))
    if us == :home
      a_pyth = t[:home_as].pyth
      b_pyth = t[:away_as].pyth
    else
      a_pyth = t[:away_as].pyth
      b_pyth = t[:home_as].pyth
    end
    puts "a_pyth: #{a_pyth}\nb_pyth: #{b_pyth}"
    100 - ((a_pyth - (b_pyth * a_pyth)) / (a_pyth + b_pyth - (2 * a_pyth * b_pyth))) * 100
    
  end
  
  def self.schedule(team_id, year)
    start = Date.new(year,1,1)
    finish = Date.new(year,12,31)
    a = Game.where(:home_team => team_id).or.where(:away_team => team_id).where(:date => start..finish).order('"date" ASC')
    return a
  end
  
  def possessions(us)
    if us == :game
      p = possessions(:home) + possessions(:away)
    else
      us == :home ? them = :away : them = :home
      p=send(us).faceoffs_won + send(us).clear_attempts + (send(them).clear_attempts - send(them).clear_success)
    end
    p
  end
  
  def pos_percentage(us)
    us == :home ? them = :away : them = :home
    ((possessions(us).to_f / possessions(:game))*100).round(2)
  end
  
  def offensive_efficiency(us)
    us == :home ? them = :away : them = :home
    ((send(us).goals.to_f / possessions(us)) * 100).round(2)
  end
  
  def faceoff_percentage(us)
    us == :home ? them = :away : them = :home
    (send(us).faceoffs_won.to_f / send(us).faceoffs_taken * 100).round(2)
  end
  
  def shots_per_possession(us)
    send(us).shot_attempts.to_f / possessions(us)
  end
  
  def shooting_percentage(us)
    (send(us).goals.to_f / send(us).shot_attempts  * 100).round(2)
  end
  
  def effective_shooting_percentage(us)
    (send(us).goals.to_f / send(us).shots_on_goal * 100).round(2)
  end
  
  def shot_accuracy(us)
    ((send(us).shots_on_goal.to_f / send(us).shot_attempts)*100).round(2)
  end
  
  def offensive_clear_rate(us)
    (send(us).clear_success.to_f / send(us).clear_attempts * 100).round(2)
  end
  
  def extra_man_conversion(us)
    if send(us).extra_man_opportunities > 0
      (send(us).extra_man_goals.to_f / send(us).extra_man_opportunities * 100).round(2)
    else
      'N/A'
    end
  end
  
  def assists_per_possession(us)
    send(us).assists.to_f / possessions(us)
  end
  
  def assists_per_goal(us)
    (send(us).assists.to_f / send(us).goals).round 4
  end
  
  def turnovers_per_possession(us)
    send(us).turnovers.to_f / possessions(us)
  end
  
  def extra_man_per_possession(us)
    send(us).extra_man_opportunities.to_f / possessions(us)
  end
  
  def man_down_per_possession(us)
    us == :home ? them = :away : them = :home
    send(them).extra_man_opportunities.to_f / possessions(us)
  end
  
  def man_down_conversion(us)
    us == :home ? them = :away : them = :home
    if send(them).extra_man_opportunities > 0
      (send(us).man_down_goals.to_f / send(them).extra_man_opportunities) * 100
    else
      'N/A'
    end
  end
  
  def save_percentage(us)
    us == :home ? them = :away : them = :home
    ( send(us).saves.to_f / send(them).shot_attempts ) * 100
  end
  
  def saves_per_possession(us)
    us == :home ? them = :away : them = :home
    ( send(us).saves.to_f / possessions(them) )
  end
  
  def goals(us)
    send(us).goals
  end
  
end
