class NationalRank < ActiveRecord::Base
  belongs_to :annual_stat, :foreign_key => :annual_stat_id
  belongs_to :team
  belongs_to :stat
  
  attr_accessible :annual_stat_id, :rank, :stat_id, :team_id, :year
end
