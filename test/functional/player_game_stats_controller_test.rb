require 'test_helper'

class PlayerGameStatsControllerTest < ActionController::TestCase
  setup do
    @player_game_stat = player_game_stats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:player_game_stats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create player_game_stat" do
    assert_difference('PlayerGameStat.count') do
      post :create, player_game_stat: { assists: @player_game_stat.assists, caused_turnovers: @player_game_stat.caused_turnovers, faceoff_wins: @player_game_stat.faceoff_wins, faceoffs_taken: @player_game_stat.faceoffs_taken, game_id: @player_game_stat.game_id, goalie_seconds: @player_game_stat.goalie_seconds, goals: @player_game_stat.goals, goals_allowed: @player_game_stat.goals_allowed, ground_balls: @player_game_stat.ground_balls, losses: @player_game_stat.losses, penalties: @player_game_stat.penalties, penalty_seconds: @player_game_stat.penalty_seconds, player_id: @player_game_stat.player_id, saves: @player_game_stat.saves, shots: @player_game_stat.shots, shots_on_goal: @player_game_stat.shots_on_goal, ties: @player_game_stat.ties, turnovers: @player_game_stat.turnovers, wins: @player_game_stat.wins }
    end

    assert_redirected_to player_game_stat_path(assigns(:player_game_stat))
  end

  test "should show player_game_stat" do
    get :show, id: @player_game_stat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @player_game_stat
    assert_response :success
  end

  test "should update player_game_stat" do
    put :update, id: @player_game_stat, player_game_stat: { assists: @player_game_stat.assists, caused_turnovers: @player_game_stat.caused_turnovers, faceoff_wins: @player_game_stat.faceoff_wins, faceoffs_taken: @player_game_stat.faceoffs_taken, game_id: @player_game_stat.game_id, goalie_seconds: @player_game_stat.goalie_seconds, goals: @player_game_stat.goals, goals_allowed: @player_game_stat.goals_allowed, ground_balls: @player_game_stat.ground_balls, losses: @player_game_stat.losses, penalties: @player_game_stat.penalties, penalty_seconds: @player_game_stat.penalty_seconds, player_id: @player_game_stat.player_id, saves: @player_game_stat.saves, shots: @player_game_stat.shots, shots_on_goal: @player_game_stat.shots_on_goal, ties: @player_game_stat.ties, turnovers: @player_game_stat.turnovers, wins: @player_game_stat.wins }
    assert_redirected_to player_game_stat_path(assigns(:player_game_stat))
  end

  test "should destroy player_game_stat" do
    assert_difference('PlayerGameStat.count', -1) do
      delete :destroy, id: @player_game_stat
    end

    assert_redirected_to player_game_stats_path
  end
end
