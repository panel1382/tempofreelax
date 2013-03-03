module TeamsHelper
  def define_which(game,teamid, us)
    if us == :us
      game.home?(teamid) ? us = :home : us = :away
    else
      game.home?(teamid) ? us = :away : us = :home
    end
    us
  end
  
  def opp(game, us)
    us == :home ? them = :away_team : them = :home_team
    us == :home ? prefix = 'vs. ' : prefix = 'at '
    
    Team.find(game.send(them))
  end
  
  def loc(game, us)
    us == :home ? label = "Home" : label = "Away"
  end
  
  def score_or_prediction(game, us)
    us == :home ? them = :away_team : them = :home_team
    output = ''
    if game.game_stats.length == 0
      output = "#{game.prediction(us).round(2).to_s}%"
    else
      if game.is_a? Game
        output = link_to("#{game.goals(us)}-#{game.goals(them)}", game)
        output.concat("  (#{game.possessions(:game)})")
      end
    end
  end
  
end
