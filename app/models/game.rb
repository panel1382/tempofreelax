class Game < ActiveRecord::Base
  has_many :game_stats
  attr_accessible :away_team, :date, :home_team, :venue, :year, :attendance,:ncaa_id
  
  def home
    if game_stats[0].home
      game_stats[0]
    else
      game_stats[1]
    end   
  end
  
  def away
    if game_stats[0].home
      game_stats[1]
    else
      game_stats[0]
    end   
  end
  
  def home?(team_id)
    home_team == team_id ? true : nil
  end
  
  def self.schedule(team_id, year)
    start = Date.new(year,1,1)
    finish = Date.new(year,12,31)
    a = Game.where(:home_team => team_id).or.where(:away_team => team_id).where(:date => start..finish).order('`date` ASC')
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
    (faceoffs_won.to_f / faceoffs_taken * 100).round(2)
  end
  
  def shooting_percentage(us)
    us == :home ? them = :away : them = :home
    (goals.to_f / shot_attempts  * 100).round(2)
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
    (send(us).extra_man_goals.to_f / send(us).extra_man_opportunities * 100).round(2)
  end
  
  def assists_per_goal(us)
    (send(us).assists.to_f / send(us).goals).round 4
  end
  
  def goals(us)
    send(us).goals
  end
end
