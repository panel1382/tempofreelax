class GameStatsController < ApplicationController
  # GET /game_stats
  # GET /game_stats.json
  def index
    @game_stats = GameStat.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @game_stats }
    end
  end

  # GET /game_stats/1
  # GET /game_stats/1.json
  def show
    @game_stat = GameStat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @game_stat }
    end
  end

  # GET /game_stats/new
  # GET /game_stats/new.json
  def new
    @game_stat = GameStat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game_stat }
    end
  end

  # GET /game_stats/1/edit
  def edit
    @game_stat = GameStat.find(params[:id])
  end

  # POST /game_stats
  # POST /game_stats.json
  def create
    @game_stat = GameStat.new(params[:game_stat])

    respond_to do |format|
      if @game_stat.save
        format.html { redirect_to @game_stat, notice: 'Game stat was successfully created.' }
        format.json { render json: @game_stat, status: :created, location: @game_stat }
      else
        format.html { render action: "new" }
        format.json { render json: @game_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /game_stats/1
  # PUT /game_stats/1.json
  def update
    @game_stat = GameStat.find(params[:id])

    respond_to do |format|
      if @game_stat.update_attributes(params[:game_stat])
        format.html { redirect_to @game_stat, notice: 'Game stat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /game_stats/1
  # DELETE /game_stats/1.json
  def destroy
    @game_stat = GameStat.find(params[:id])
    @game_stat.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
end
