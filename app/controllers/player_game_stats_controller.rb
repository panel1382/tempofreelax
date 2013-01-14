class PlayerGameStatsController < ApplicationController
  # GET /player_game_stats
  # GET /player_game_stats.json
  def index
    @player_game_stats = PlayerGameStat.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @player_game_stats }
    end
  end

  # GET /player_game_stats/1
  # GET /player_game_stats/1.json
  def show
    @player_game_stat = PlayerGameStat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @player_game_stat }
    end
  end

  # GET /player_game_stats/new
  # GET /player_game_stats/new.json
  def new
    @player_game_stat = PlayerGameStat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @player_game_stat }
    end
  end

  # GET /player_game_stats/1/edit
  def edit
    @player_game_stat = PlayerGameStat.find(params[:id])
  end

  # POST /player_game_stats
  # POST /player_game_stats.json
  def create
    @player_game_stat = PlayerGameStat.new(params[:player_game_stat])

    respond_to do |format|
      if @player_game_stat.save
        format.html { redirect_to @player_game_stat, notice: 'Player game stat was successfully created.' }
        format.json { render json: @player_game_stat, status: :created, location: @player_game_stat }
      else
        format.html { render action: "new" }
        format.json { render json: @player_game_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /player_game_stats/1
  # PUT /player_game_stats/1.json
  def update
    @player_game_stat = PlayerGameStat.find(params[:id])

    respond_to do |format|
      if @player_game_stat.update_attributes(params[:player_game_stat])
        format.html { redirect_to @player_game_stat, notice: 'Player game stat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @player_game_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /player_game_stats/1
  # DELETE /player_game_stats/1.json
  def destroy
    @player_game_stat = PlayerGameStat.find(params[:id])
    @player_game_stat.destroy

    respond_to do |format|
      format.html { redirect_to player_game_stats_url }
      format.json { head :no_content }
    end
  end
end
