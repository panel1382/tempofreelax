module AnnualStatsHelper
  def stat_with_rank(stat,o, percent = false, precision = 2)
    stat = stat.to_sym if stat.is_a? String
    if !o.send(stat).nil?
      string = (o.send(stat).round(precision)).to_s
      string+= '%' if percent == true
      string+= " (#{o.ranks[stat]})"
    end  
  end
end
