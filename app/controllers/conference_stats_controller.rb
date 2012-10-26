class ConferenceStatsController < ApplicationController
  # GET /conference_stats
  # GET /conference_stats.json
  def index
    start = Date.new(params[:year].to_i,1,1)
    finish = Date.new(params[:year].to_i,12,31)
    
    @conference_stats = ConferenceStat.where(:conference_id => params[:conference_id], :year => start..finish).all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conference_stats }
    end
  end

  # GET /conference_stats/1
  # GET /conference_stats/1.json
  def show
    @conference_stat = ConferenceStat.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conference_stat }
    end
  end

  # GET /conference_stats/new
  # GET /conference_stats/new.json
  def new
    @conference_stat = ConferenceStat.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @conference_stat }
    end
  end

  # GET /conference_stats/1/edit
  def edit
    @conference_stat = ConferenceStat.find(params[:id])
  end

  # POST /conference_stats
  # POST /conference_stats.json
  def create
    @conference_stat = ConferenceStat.new(params[:conference_stat])

    respond_to do |format|
      if @conference_stat.save
        format.html { redirect_to @conference_stat, notice: 'Conference stat was successfully created.' }
        format.json { render json: @conference_stat, status: :created, location: @conference_stat }
      else
        format.html { render action: "new" }
        format.json { render json: @conference_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /conference_stats/1
  # PUT /conference_stats/1.json
  def update
    @conference_stat = ConferenceStat.find(params[:id])

    respond_to do |format|
      if @conference_stat.update_attributes(params[:conference_stat])
        format.html { redirect_to @conference_stat, notice: 'Conference stat was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @conference_stat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conference_stats/1
  # DELETE /conference_stats/1.json
  def destroy
    @conference_stat = ConferenceStat.find(params[:id])
    @conference_stat.destroy

    respond_to do |format|
      format.html { redirect_to conference_stats_url }
      format.json { head :no_content }
    end
  end
end
