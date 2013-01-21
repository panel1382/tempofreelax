class AnnualStatsController < ApplicationController
  # GET /annual_stats
  # GET /annual_stats.json
  def index
    params['year'].nil? ? @year = Date.today.year : @year = params['year'].to_i
    start = Date.new(@year,1,1)
    finish = Date.new(@year,12,31)
    @annual_stats = AnnualStat.where(:year => start..finish)
    @years = AnnualStat.available_years
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @annual_stats }
    end
  end

  # GET /annual_stats/1
  # GET /annual_stats/1.json
  def show
    @annual_stat = AnnualStat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @annual_stat }
    end
  end

  # GET /annual_stats/new
  # GET /annual_stats/new.json
  def new
    @annual_stat = AnnualStat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @annual_stat }
    end
  end

  # GET /annual_stats/1/edit
  def edit
    @annual_stat = AnnualStat.find(params[:id])
  end

  # POST /annual_stats
  # POST /annual_stats.json
  def create
    @annual_stat = AnnualStat.new(params[:annual_stat])

    respond_to do |format|
      if @annual_stat.save
        format.html { redirect_to @annual_stat, notice: 'Annual stat was successfully created.' }
        format.json { render json: @annual_stat, status: :created, location: @annual_stat }
      else
        format.html { render action: "new" }
        format.json { render json: @annual_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /annual_stats/1
  # PUT /annual_stats/1.json
  def update
    @annual_stat = AnnualStat.find(params[:id])

    respond_to do |format|
      if @annual_stat.update_attributes(params[:annual_stat])
        format.html { redirect_to @annual_stat, notice: 'Annual stat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @annual_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /annual_stats/1
  # DELETE /annual_stats/1.json
  def destroy
    @annual_stat = AnnualStat.find(params[:id])
    @annual_stat.destroy

    respond_to do |format|
      format.html { redirect_to annual_stats_url }
      format.json { head :no_content }
    end
  end
end
