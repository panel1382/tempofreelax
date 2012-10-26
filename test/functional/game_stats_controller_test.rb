require 'test_helper'

class GameStatsControllerTest < ActionController::TestCase
  setup do
    @game_stat = game_stats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:game_stats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create game_stat" do
    assert_difference('GameStat.count') do
      post :create, game_stat: { assists: @game_stat.assists, clear_attempts: @game_stat.clear_attempts, clear_success: @game_stat.clear_success, extra_man_goals: @game_stat.extra_man_goals, extra_man_opportunities: @game_stat.extra_man_opportunities, faceoff_percentage: @game_stat.faceoff_percentage, faceoffs_won: @game_stat.faceoffs_won, game_id: @game_stat.game_id, goals: @game_stat.goals, home: @game_stat.home, man_down_goals: @game_stat.man_down_goals, penalties: @game_stat.penalties, shot_attempts: @game_stat.shot_attempts, shots_on_goal: @game_stat.shots_on_goal, team_id: @game_stat.team_id }
    end

    assert_redirected_to game_stat_path(assigns(:game_stat))
  end

  test "should show game_stat" do
    get :show, id: @game_stat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @game_stat
    assert_response :success
  end

  test "should update game_stat" do
    put :update, id: @game_stat, game_stat: { assists: @game_stat.assists, clear_attempts: @game_stat.clear_attempts, clear_success: @game_stat.clear_success, extra_man_goals: @game_stat.extra_man_goals, extra_man_opportunities: @game_stat.extra_man_opportunities, faceoff_percentage: @game_stat.faceoff_percentage, faceoffs_won: @game_stat.faceoffs_won, game_id: @game_stat.game_id, goals: @game_stat.goals, home: @game_stat.home, man_down_goals: @game_stat.man_down_goals, penalties: @game_stat.penalties, shot_attempts: @game_stat.shot_attempts, shots_on_goal: @game_stat.shots_on_goal, team_id: @game_stat.team_id }
    assert_redirected_to game_stat_path(assigns(:game_stat))
  end

  test "should destroy game_stat" do
    assert_difference('GameStat.count', -1) do
      delete :destroy, id: @game_stat
    end

    assert_redirected_to game_stats_path
  end
end
