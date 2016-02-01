class ApiCallLogsController < ApplicationController
  before_action :set_api_call_log, only: [:show, :edit, :update, :destroy]

  # GET /api_call_logs
  # GET /api_call_logs.json
  def index
    @api_call_logs = ApiCallLog.all
  end

  # GET /api_call_logs/1
  # GET /api_call_logs/1.json
  def show
  end

  # GET /api_call_logs/new
  def new
    @api_call_log = ApiCallLog.new
  end

  # GET /api_call_logs/1/edit
  def edit
  end

  # POST /api_call_logs
  # POST /api_call_logs.json
  def create
    @api_call_log = ApiCallLog.new(api_call_log_params)

    respond_to do |format|
      if @api_call_log.save
        format.html { redirect_to @api_call_log, notice: 'Api call log was successfully created.' }
        format.json { render :show, status: :created, location: @api_call_log }
      else
        format.html { render :new }
        format.json { render json: @api_call_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api_call_logs/1
  # PATCH/PUT /api_call_logs/1.json
  def update
    respond_to do |format|
      if @api_call_log.update(api_call_log_params)
        format.html { redirect_to @api_call_log, notice: 'Api call log was successfully updated.' }
        format.json { render :show, status: :ok, location: @api_call_log }
      else
        format.html { render :edit }
        format.json { render json: @api_call_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api_call_logs/1
  # DELETE /api_call_logs/1.json
  def destroy
    @api_call_log.destroy
    respond_to do |format|
      format.html { redirect_to api_call_logs_url, notice: 'Api call log was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_call_log
      @api_call_log = ApiCallLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_call_log_params
      params.require(:api_call_log).permit(:calldescription, :calldatetime, :successful)
    end
end
