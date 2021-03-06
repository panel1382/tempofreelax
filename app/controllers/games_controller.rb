class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    require 'date'
    
    if params[:date]
      arr = params[:date].split('-')
      @date = Date.new arr[0].to_i, arr[1].to_i, arr[2].to_i
    else
      @date = Date.today
    end
    date = @date.to_s + '%'
    @games = Game.where(:date => date)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @games }
    end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game = Game.find(params[:id])
    @home = AnnualStat.where(:year => Date.new(@game.date.year), :team_id => @game.teams[:home].id).first
    @away = AnnualStat.where(:year => Date.new(@game.date.year), :team_id => @game.teams[:away].id).first
    
    @prev = Game.find(params[:id].to_i - 1)
    @next = Game.find(params[:id].to_i + 1)
    
    respond_to do |format|
      format.html { @game.ncaa_id.nil? ? render('preview') : render('show') }
      format.json { render json: @game }
    end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create
    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end
  
  def audit
    require 'date'
    @year = params[:year].to_i
    range = (Date.new(@year,1,1))..(Date.new(@year,12,31))
    @games = Game.where :date => range
  end
end
