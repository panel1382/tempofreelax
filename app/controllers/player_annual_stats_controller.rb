class PlayerAnnualStatsController < ApplicationController
  # GET /player_annual_stats
  # GET /player_annual_stats.json
  def index
    @player_annual_stats = PlayerAnnualStat.where('').page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @player_annual_stats }
    end
  end

  # GET /player_annual_stats/1
  # GET /player_annual_stats/1.json
  def show
    @player_annual_stat = PlayerAnnualStat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @player_annual_stat }
    end
  end

  # GET /player_annual_stats/new
  # GET /player_annual_stats/new.json
  def new
    @player_annual_stat = PlayerAnnualStat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @player_annual_stat }
    end
  end

  # GET /player_annual_stats/1/edit
  def edit
    @player_annual_stat = PlayerAnnualStat.find(params[:id])
  end

  # POST /player_annual_stats
  # POST /player_annual_stats.json
  def create
    @player_annual_stat = PlayerAnnualStat.new(params[:player_annual_stat])

    respond_to do |format|
      if @player_annual_stat.save
        format.html { redirect_to @player_annual_stat, notice: 'Player annual stat was successfully created.' }
        format.json { render json: @player_annual_stat, status: :created, location: @player_annual_stat }
      else
        format.html { render action: "new" }
        format.json { render json: @player_annual_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /player_annual_stats/1
  # PUT /player_annual_stats/1.json
  def update
    @player_annual_stat = PlayerAnnualStat.find(params[:id])

    respond_to do |format|
      if @player_annual_stat.update_attributes(params[:player_annual_stat])
        format.html { redirect_to @player_annual_stat, notice: 'Player annual stat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @player_annual_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /player_annual_stats/1
  # DELETE /player_annual_stats/1.json
  def destroy
    @player_annual_stat = PlayerAnnualStat.find(params[:id])
    @player_annual_stat.destroy

    respond_to do |format|
      format.html { redirect_to player_annual_stats_url }
      format.json { head :no_content }
    end
  end
end
