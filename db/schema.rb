# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130403024729) do

  create_table "annual_stats", :force => true do |t|
    t.integer  "team_id"
    t.integer  "rank_id"
    t.date     "year"
    t.integer  "games"
    t.integer  "wins"
    t.integer  "goals"
    t.integer  "shot_attempts"
    t.integer  "shots_on_goal"
    t.integer  "assists"
    t.integer  "faceoffs_won"
    t.integer  "opp_faceoffs_won"
    t.integer  "clear_attempts"
    t.integer  "clear_success"
    t.integer  "extra_man_opportunities"
    t.integer  "extra_man_goals"
    t.integer  "opp_extra_man_opportunities"
    t.integer  "man_down_goals"
    t.integer  "opp_goals"
    t.integer  "opp_shot_attempts"
    t.integer  "opp_shots_on_goal"
    t.integer  "opp_assists"
    t.integer  "opp_extra_man_goals"
    t.integer  "opp_clear_attempts"
    t.integer  "opp_clear_success"
    t.integer  "opp_man_down_goals"
    t.float    "def_adj",                     :default => 1.0
    t.float    "off_adj",                     :default => 1.0
    t.integer  "conference_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "ground_balls"
    t.integer  "turnovers"
    t.integer  "caused_turnovers"
    t.integer  "penalty_time"
    t.integer  "opp_ground_balls"
    t.integer  "opp_turnovers"
    t.integer  "opp_caused_turnovers"
    t.integer  "opp_penalty_time"
    t.integer  "penalties"
    t.integer  "opp_penalties"
    t.integer  "faceoffs_taken"
    t.float    "opp_pyth"
  end

  create_table "conference_stats", :force => true do |t|
    t.integer  "team_id"
    t.integer  "conference_id"
    t.integer  "as_id"
    t.integer  "rank_id"
    t.date     "year"
    t.integer  "games"
    t.integer  "wins"
    t.integer  "goals"
    t.integer  "shot_attempts"
    t.integer  "shots_on_goal"
    t.integer  "assists"
    t.integer  "faceoffs_won"
    t.integer  "opp_faceoffs_won"
    t.integer  "clear_attempts"
    t.integer  "clear_success"
    t.integer  "extra_man_opportunities"
    t.integer  "extra_man_goals"
    t.integer  "opp_extra_man_opportunities"
    t.integer  "man_down_goals"
    t.integer  "opp_goals"
    t.integer  "opp_shot_attempts"
    t.integer  "opp_shots_on_goal"
    t.integer  "opp_assists"
    t.integer  "opp_extra_man_goals"
    t.integer  "opp_clear_attempts"
    t.integer  "opp_clear_success"
    t.integer  "opp_man_down_goals"
    t.decimal  "def_adj",                     :default => 1.0
    t.decimal  "off_adj",                     :default => 1.0
    t.integer  "ground_balls"
    t.integer  "opp_ground_balls"
    t.integer  "turnovers"
    t.integer  "opp_turnovers"
    t.integer  "caused_turnovers"
    t.integer  "opp_caused_turnovers"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.integer  "faceoffs_taken"
    t.integer  "penalty_time"
    t.integer  "penalties"
    t.integer  "opp_penalty_time"
    t.integer  "opp_penalties"
  end

  create_table "conferences", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "game_stats", :force => true do |t|
    t.integer  "team_id"
    t.boolean  "home"
    t.integer  "game_id"
    t.integer  "goals"
    t.integer  "shot_attempts"
    t.integer  "shots_on_goal"
    t.integer  "assists"
    t.integer  "faceoffs_won"
    t.float    "faceoff_percentage"
    t.integer  "clear_attempts"
    t.integer  "clear_success"
    t.integer  "extra_man_opportunities"
    t.integer  "extra_man_goals"
    t.integer  "man_down_goals"
    t.integer  "penalties"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
    t.integer  "ground_balls"
    t.integer  "turnovers"
    t.integer  "caused_turnovers"
    t.integer  "penalty_time"
    t.integer  "faceoffs_taken"
    t.integer  "saves"
  end

  create_table "games", :force => true do |t|
    t.integer  "home_team"
    t.integer  "away_team"
    t.date     "year"
    t.string   "venue"
    t.date     "date"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "attendance"
    t.string   "ncaa_id"
  end

  create_table "national_ranks", :force => true do |t|
    t.integer  "stat_id"
    t.integer  "team_id"
    t.integer  "annual_stat_id"
    t.integer  "year"
    t.integer  "rank"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "conference",     :default => false
  end

  create_table "player_annual_stats", :force => true do |t|
    t.integer  "assists"
    t.integer  "caused_turnovers"
    t.integer  "faceoffs_won"
    t.integer  "faceoffs_taken"
    t.integer  "game_id"
    t.integer  "goalie_seconds"
    t.integer  "goals"
    t.integer  "goals_allowed"
    t.integer  "ground_balls"
    t.integer  "losses"
    t.integer  "penalties"
    t.integer  "penalty_time"
    t.integer  "player_id"
    t.integer  "saves"
    t.integer  "shot_attempts"
    t.integer  "shots_on_goal"
    t.integer  "ties"
    t.integer  "turnovers"
    t.integer  "wins"
    t.integer  "extra_man_goals"
    t.integer  "man_down_goals"
    t.date     "year"
    t.integer  "team_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "possessions"
    t.string   "opp_possessions"
    t.string   "position"
    t.boolean  "faceoff_specialist"
  end

  create_table "player_game_stats", :force => true do |t|
    t.integer  "player_id"
    t.integer  "game_id"
    t.integer  "goals"
    t.integer  "assists"
    t.integer  "shot_attempts"
    t.integer  "shots_on_goal"
    t.integer  "ground_balls"
    t.integer  "turnovers"
    t.integer  "caused_turnovers"
    t.integer  "faceoffs_won"
    t.integer  "faceoffs_taken"
    t.integer  "penalties"
    t.integer  "penalty_time"
    t.integer  "goalie_seconds"
    t.integer  "goals_allowed"
    t.integer  "saves"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "ties"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "man_down_goals"
    t.integer  "extra_man_goals"
  end

  create_table "players", :force => true do |t|
    t.integer  "team_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "first_name"
    t.string   "last_name"
  end

  create_table "positions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "stats", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "slug"
    t.string   "order",        :default => "descending"
    t.string   "abbreviation"
  end

  create_table "teams", :force => true do |t|
    t.integer  "conference_id"
    t.string   "home_field"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "name"
  end

  create_table "votes", :force => true do |t|
    t.integer  "player_id"
    t.integer  "position_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
