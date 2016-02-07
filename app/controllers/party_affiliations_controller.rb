class PartyAffiliationsController < ApplicationController
  before_action :set_party_affiliation, only: [:show, :edit, :update, :destroy]

  # GET /party_affiliations
  # GET /party_affiliations.json
  def index
    @party_affiliations = PartyAffiliation.all
  end

  # GET /party_affiliations/1
  # GET /party_affiliations/1.json
  def show
  end

  # GET /party_affiliations/new
  def new
    @party_affiliation = PartyAffiliation.new
  end

  # GET /party_affiliations/1/edit
  def edit
  end

  # POST /party_affiliations
  # POST /party_affiliations.json
  def create
    @party_affiliation = PartyAffiliation.new(party_affiliation_params)

    respond_to do |format|
      if @party_affiliation.save
        format.html { redirect_to @party_affiliation, notice: 'Party affiliation was successfully created.' }
        format.json { render :show, status: :created, location: @party_affiliation }
      else
        format.html { render :new }
        format.json { render json: @party_affiliation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /party_affiliations/1
  # PATCH/PUT /party_affiliations/1.json
  def update
    respond_to do |format|
      if @party_affiliation.update(party_affiliation_params)
        format.html { redirect_to @party_affiliation, notice: 'Party affiliation was successfully updated.' }
        format.json { render :show, status: :ok, location: @party_affiliation }
      else
        format.html { render :edit }
        format.json { render json: @party_affiliation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /party_affiliations/1
  # DELETE /party_affiliations/1.json
  def destroy
    @party_affiliation.destroy
    respond_to do |format|
      format.html { redirect_to party_affiliations_url, notice: 'Party affiliation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_party_affiliation
      @party_affiliation = PartyAffiliation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def party_affiliation_params
      params.require(:party_affiliation).permit(:partyAffiliation, :partyColour)
    end
end
