require 'test_helper'

class AnnualStatsControllerTest < ActionController::TestCase
  setup do
    @annual_stat = annual_stats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:annual_stats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create annual_stat" do
    assert_difference('AnnualStat.count') do
      post :create, annual_stat: { assists: @annual_stat.assists, clear_attempts: @annual_stat.clear_attempts, clear_success: @annual_stat.clear_success, conference_id: @annual_stat.conference_id, def_adj: @annual_stat.def_adj, extra_man_goals: @annual_stat.extra_man_goals, extra_man_opportunities: @annual_stat.extra_man_opportunities, faceoffs_won: @annual_stat.faceoffs_won, games: @annual_stat.games, goals: @annual_stat.goals, man_down_goals: @annual_stat.man_down_goals, off_adj: @annual_stat.off_adj, opp_assists: @annual_stat.opp_assists, opp_clear_attempts: @annual_stat.opp_clear_attempts, opp_clear_success: @annual_stat.opp_clear_success, opp_extra_man_goals: @annual_stat.opp_extra_man_goals, opp_extra_man_opportunities: @annual_stat.opp_extra_man_opportunities, opp_faceoffs_won: @annual_stat.opp_faceoffs_won, opp_goals: @annual_stat.opp_goals, opp_man_down_goals: @annual_stat.opp_man_down_goals, opp_shot_attempts: @annual_stat.opp_shot_attempts, opp_shots_on_goal: @annual_stat.opp_shots_on_goal, rank_id: @annual_stat.rank_id, shot_attempts: @annual_stat.shot_attempts, shots_on_goal: @annual_stat.shots_on_goal, team_id: @annual_stat.team_id, wins: @annual_stat.wins, year: @annual_stat.year }
    end

    assert_redirected_to annual_stat_path(assigns(:annual_stat))
  end

  test "should show annual_stat" do
    get :show, id: @annual_stat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @annual_stat
    assert_response :success
  end

  test "should update annual_stat" do
    put :update, id: @annual_stat, annual_stat: { assists: @annual_stat.assists, clear_attempts: @annual_stat.clear_attempts, clear_success: @annual_stat.clear_success, conference_id: @annual_stat.conference_id, def_adj: @annual_stat.def_adj, extra_man_goals: @annual_stat.extra_man_goals, extra_man_opportunities: @annual_stat.extra_man_opportunities, faceoffs_won: @annual_stat.faceoffs_won, games: @annual_stat.games, goals: @annual_stat.goals, man_down_goals: @annual_stat.man_down_goals, off_adj: @annual_stat.off_adj, opp_assists: @annual_stat.opp_assists, opp_clear_attempts: @annual_stat.opp_clear_attempts, opp_clear_success: @annual_stat.opp_clear_success, opp_extra_man_goals: @annual_stat.opp_extra_man_goals, opp_extra_man_opportunities: @annual_stat.opp_extra_man_opportunities, opp_faceoffs_won: @annual_stat.opp_faceoffs_won, opp_goals: @annual_stat.opp_goals, opp_man_down_goals: @annual_stat.opp_man_down_goals, opp_shot_attempts: @annual_stat.opp_shot_attempts, opp_shots_on_goal: @annual_stat.opp_shots_on_goal, rank_id: @annual_stat.rank_id, shot_attempts: @annual_stat.shot_attempts, shots_on_goal: @annual_stat.shots_on_goal, team_id: @annual_stat.team_id, wins: @annual_stat.wins, year: @annual_stat.year }
    assert_redirected_to annual_stat_path(assigns(:annual_stat))
  end

  test "should destroy annual_stat" do
    assert_difference('AnnualStat.count', -1) do
      delete :destroy, id: @annual_stat
    end

    assert_redirected_to annual_stats_path
  end
end
