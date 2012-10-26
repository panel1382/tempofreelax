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
    us == :home ? them = :away : them = :home
    us == :home ? prefix = 'vs. ' : prefix = 'at '
    
    name = Team.find(game.send(them).team_id).name
    prefix + name
  end
end
