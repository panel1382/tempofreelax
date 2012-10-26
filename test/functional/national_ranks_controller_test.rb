require 'test_helper'

class NationalRanksControllerTest < ActionController::TestCase
  setup do
    @national_rank = national_ranks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:national_ranks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create national_rank" do
    assert_difference('NationalRank.count') do
      post :create, national_rank: { annual_stat_id: @national_rank.annual_stat_id, rank: @national_rank.rank, stat_id: @national_rank.stat_id, team_id: @national_rank.team_id, year: @national_rank.year }
    end

    assert_redirected_to national_rank_path(assigns(:national_rank))
  end

  test "should show national_rank" do
    get :show, id: @national_rank
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @national_rank
    assert_response :success
  end

  test "should update national_rank" do
    put :update, id: @national_rank, national_rank: { annual_stat_id: @national_rank.annual_stat_id, rank: @national_rank.rank, stat_id: @national_rank.stat_id, team_id: @national_rank.team_id, year: @national_rank.year }
    assert_redirected_to national_rank_path(assigns(:national_rank))
  end

  test "should destroy national_rank" do
    assert_difference('NationalRank.count', -1) do
      delete :destroy, id: @national_rank
    end

    assert_redirected_to national_ranks_path
  end
end
