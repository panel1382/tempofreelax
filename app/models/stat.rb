class Stat < ActiveRecord::Base
  has_many :national_ranks
  attr_accessible :description, :name, :slug, :abbreviation, :order
end
