require 'test_helper'

class PlayerAnnualStatsControllerTest < ActionController::TestCase
  setup do
    @player_annual_stat = player_annual_stats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:player_annual_stats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create player_annual_stat" do
    assert_difference('PlayerAnnualStat.count') do
      post :create, player_annual_stat: { assists: @player_annual_stat.assists, caused_turnovers: @player_annual_stat.caused_turnovers, extra_man_goals: @player_annual_stat.extra_man_goals, faceoff_wins: @player_annual_stat.faceoff_wins, faceoffs_taken: @player_annual_stat.faceoffs_taken, game_id: @player_annual_stat.game_id, goalie_seconds: @player_annual_stat.goalie_seconds, goals: @player_annual_stat.goals, goals_allowed: @player_annual_stat.goals_allowed, ground_balls: @player_annual_stat.ground_balls, losses: @player_annual_stat.losses, man_down_goals: @player_annual_stat.man_down_goals, penalties: @player_annual_stat.penalties, penalty_time: @player_annual_stat.penalty_time, player_id: @player_annual_stat.player_id, saves: @player_annual_stat.saves, shot_attempts: @player_annual_stat.shot_attempts, shots_on_goal: @player_annual_stat.shots_on_goal, team_id: @player_annual_stat.team_id, ties: @player_annual_stat.ties, turnovers: @player_annual_stat.turnovers, wins: @player_annual_stat.wins, year: @player_annual_stat.year }
    end

    assert_redirected_to player_annual_stat_path(assigns(:player_annual_stat))
  end

  test "should show player_annual_stat" do
    get :show, id: @player_annual_stat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @player_annual_stat
    assert_response :success
  end

  test "should update player_annual_stat" do
    put :update, id: @player_annual_stat, player_annual_stat: { assists: @player_annual_stat.assists, caused_turnovers: @player_annual_stat.caused_turnovers, extra_man_goals: @player_annual_stat.extra_man_goals, faceoff_wins: @player_annual_stat.faceoff_wins, faceoffs_taken: @player_annual_stat.faceoffs_taken, game_id: @player_annual_stat.game_id, goalie_seconds: @player_annual_stat.goalie_seconds, goals: @player_annual_stat.goals, goals_allowed: @player_annual_stat.goals_allowed, ground_balls: @player_annual_stat.ground_balls, losses: @player_annual_stat.losses, man_down_goals: @player_annual_stat.man_down_goals, penalties: @player_annual_stat.penalties, penalty_time: @player_annual_stat.penalty_time, player_id: @player_annual_stat.player_id, saves: @player_annual_stat.saves, shot_attempts: @player_annual_stat.shot_attempts, shots_on_goal: @player_annual_stat.shots_on_goal, team_id: @player_annual_stat.team_id, ties: @player_annual_stat.ties, turnovers: @player_annual_stat.turnovers, wins: @player_annual_stat.wins, year: @player_annual_stat.year }
    assert_redirected_to player_annual_stat_path(assigns(:player_annual_stat))
  end

  test "should destroy player_annual_stat" do
    assert_difference('PlayerAnnualStat.count', -1) do
      delete :destroy, id: @player_annual_stat
    end

    assert_redirected_to player_annual_stats_path
  end
end
