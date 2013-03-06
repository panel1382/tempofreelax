class GameStat < ActiveRecord::Base
  belongs_to :game
  attr_accessible :assists, :clear_attempts, :clear_success, :extra_man_goals, :extra_man_opportunities, :faceoff_percentage, :faceoffs_won, :game_id, :goals, :home, :man_down_goals, :penalties, :shot_attempts, :shots_on_goal, :team_id, :ground_balls, :turnovers, :caused_turnovers, :penalty_time, :saves, :faceoffs_taken

  
  def self.statKey 
    {
    :goals => 0,
    :assists => 1,
    :points => 2,
    :shots => 3,
    :shots_on_goal => 4,
    :extra_man_goals => 5,
    :man_down_goals => 6,
    :ground_balls => 7,
    :turnovers => 8,
    :caused_turnovers => 9,
    :faceoffs_won => 10,
    :faceoffs => 11,
    :penalties => 12,
    :penalty_time => 13,
    :opp_goals => 15,
    :saves => 16,
    :rc => 17,
    :yc => 18
    }
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
  
  def shot_accuracy
    shots_on_goal / shot_attempts
  end
  
  def offensive_clear_rate
    clear_success.to_f / clear_attempts * 100
  end
  
  def extra_man_conversion
    if extra_man_opportunities > 0
      extra_man_goals.to_f / extra_man_opportunities * 100
    else
      "N/A"
    end
  end
  
  def emo_reliance
    extra_man_goals.to_f / goals * 100
  end
  
  def man_down_reliance
    man_down_goals.to_f / goals * 100
  end
  
  def assists_per_goal
    assists.to_f / goals
  end 
end