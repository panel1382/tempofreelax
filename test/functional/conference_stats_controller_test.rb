require 'test_helper'

class ConferenceStatsControllerTest < ActionController::TestCase
  setup do
    @conference_stat = conference_stats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:conference_stats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create conference_stat" do
    assert_difference('ConferenceStat.count') do
      post :create, conference_stat: { as_id: @conference_stat.as_id, assists: @conference_stat.assists, caused_turnovers: @conference_stat.caused_turnovers, clear_attempts: @conference_stat.clear_attempts, clear_success: @conference_stat.clear_success, conference_id: @conference_stat.conference_id, conference_id: @conference_stat.conference_id, def_adj: @conference_stat.def_adj, extra_man_goals: @conference_stat.extra_man_goals, extra_man_opportunities: @conference_stat.extra_man_opportunities, faceoffs_won: @conference_stat.faceoffs_won, games: @conference_stat.games, goals: @conference_stat.goals, ground_balls: @conference_stat.ground_balls, man_down_goals: @conference_stat.man_down_goals, off_adj: @conference_stat.off_adj, opp_assists: @conference_stat.opp_assists, opp_caused_turnovers: @conference_stat.opp_caused_turnovers, opp_clear_attempts: @conference_stat.opp_clear_attempts, opp_clear_success: @conference_stat.opp_clear_success, opp_extra_man_goals: @conference_stat.opp_extra_man_goals, opp_extra_man_opportunities: @conference_stat.opp_extra_man_opportunities, opp_faceoffs_won: @conference_stat.opp_faceoffs_won, opp_goals: @conference_stat.opp_goals, opp_ground_balls: @conference_stat.opp_ground_balls, opp_man_down_goals: @conference_stat.opp_man_down_goals, opp_shot_attempts: @conference_stat.opp_shot_attempts, opp_shots_on_goal: @conference_stat.opp_shots_on_goal, opp_turnovers: @conference_stat.opp_turnovers, rank_id: @conference_stat.rank_id, shot_attempts: @conference_stat.shot_attempts, shots_on_goal: @conference_stat.shots_on_goal, team_id: @conference_stat.team_id, turnovers: @conference_stat.turnovers, wins: @conference_stat.wins, year: @conference_stat.year }
    end

    assert_redirected_to conference_stat_path(assigns(:conference_stat))
  end

  test "should show conference_stat" do
    get :show, id: @conference_stat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @conference_stat
    assert_response :success
  end

  test "should update conference_stat" do
    put :update, id: @conference_stat, conference_stat: { as_id: @conference_stat.as_id, assists: @conference_stat.assists, caused_turnovers: @conference_stat.caused_turnovers, clear_attempts: @conference_stat.clear_attempts, clear_success: @conference_stat.clear_success, conference_id: @conference_stat.conference_id, conference_id: @conference_stat.conference_id, def_adj: @conference_stat.def_adj, extra_man_goals: @conference_stat.extra_man_goals, extra_man_opportunities: @conference_stat.extra_man_opportunities, faceoffs_won: @conference_stat.faceoffs_won, games: @conference_stat.games, goals: @conference_stat.goals, ground_balls: @conference_stat.ground_balls, man_down_goals: @conference_stat.man_down_goals, off_adj: @conference_stat.off_adj, opp_assists: @conference_stat.opp_assists, opp_caused_turnovers: @conference_stat.opp_caused_turnovers, opp_clear_attempts: @conference_stat.opp_clear_attempts, opp_clear_success: @conference_stat.opp_clear_success, opp_extra_man_goals: @conference_stat.opp_extra_man_goals, opp_extra_man_opportunities: @conference_stat.opp_extra_man_opportunities, opp_faceoffs_won: @conference_stat.opp_faceoffs_won, opp_goals: @conference_stat.opp_goals, opp_ground_balls: @conference_stat.opp_ground_balls, opp_man_down_goals: @conference_stat.opp_man_down_goals, opp_shot_attempts: @conference_stat.opp_shot_attempts, opp_shots_on_goal: @conference_stat.opp_shots_on_goal, opp_turnovers: @conference_stat.opp_turnovers, rank_id: @conference_stat.rank_id, shot_attempts: @conference_stat.shot_attempts, shots_on_goal: @conference_stat.shots_on_goal, team_id: @conference_stat.team_id, turnovers: @conference_stat.turnovers, wins: @conference_stat.wins, year: @conference_stat.year }
    assert_redirected_to conference_stat_path(assigns(:conference_stat))
  end

  test "should destroy conference_stat" do
    assert_difference('ConferenceStat.count', -1) do
      delete :destroy, id: @conference_stat
    end

    assert_redirected_to conference_stats_path
  end
end
