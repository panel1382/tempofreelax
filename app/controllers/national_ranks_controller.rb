class NationalRanksController < ApplicationController
  # GET /national_ranks
  # GET /national_ranks.json
  def index
    @national_ranks = NationalRank.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @national_ranks }
    end
  end

  # GET /national_ranks/1
  # GET /national_ranks/1.json
  def show
    @national_rank = NationalRank.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @national_rank }
    end
  end

  # GET /national_ranks/new
  # GET /national_ranks/new.json
  def new
    @national_rank = NationalRank.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @national_rank }
    end
  end

  # GET /national_ranks/1/edit
  def edit
    @national_rank = NationalRank.find(params[:id])
  end

  # POST /national_ranks
  # POST /national_ranks.json
  def create
    @national_rank = NationalRank.new(params[:national_rank])

    respond_to do |format|
      if @national_rank.save
        format.html { redirect_to @national_rank, notice: 'National rank was successfully created.' }
        format.json { render json: @national_rank, status: :created, location: @national_rank }
      else
        format.html { render action: "new" }
        format.json { render json: @national_rank.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /national_ranks/1
  # PUT /national_ranks/1.json
  def update
    @national_rank = NationalRank.find(params[:id])

    respond_to do |format|
      if @national_rank.update_attributes(params[:national_rank])
        format.html { redirect_to @national_rank, notice: 'National rank was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @national_rank.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /national_ranks/1
  # DELETE /national_ranks/1.json
  def destroy
    @national_rank = NationalRank.find(params[:id])
    @national_rank.destroy

    respond_to do |format|
      format.html { redirect_to national_ranks_url }
      format.json { head :no_content }
    end
  end
end
