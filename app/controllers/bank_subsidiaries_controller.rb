class BankSubsidiariesController < ApplicationController
  before_action :set_bank_subsidiary, only: [:show, :edit, :update, :destroy]

  # GET /bank_subsidiaries
  # GET /bank_subsidiaries.json
  def index
    @bank_subsidiaries = BankSubsidiary.all
  end

  # GET /bank_subsidiaries/1
  # GET /bank_subsidiaries/1.json
  def show
  end

  # GET /bank_subsidiaries/new
  def new
    @bank_subsidiary = BankSubsidiary.new
  end

  # GET /bank_subsidiaries/1/edit
  def edit
  end

  # POST /bank_subsidiaries
  # POST /bank_subsidiaries.json
  def create
    @bank_subsidiary = BankSubsidiary.new(bank_subsidiary_params)

    respond_to do |format|
      if @bank_subsidiary.save
        format.html { redirect_to @bank_subsidiary, notice: 'Bank subsidiary was successfully created.' }
        format.json { render :show, status: :created, location: @bank_subsidiary }
      else
        format.html { render :new }
        format.json { render json: @bank_subsidiary.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bank_subsidiaries/1
  # PATCH/PUT /bank_subsidiaries/1.json
  def update
    respond_to do |format|
      if @bank_subsidiary.update(bank_subsidiary_params)
        format.html { redirect_to @bank_subsidiary, notice: 'Bank subsidiary was successfully updated.' }
        format.json { render :show, status: :ok, location: @bank_subsidiary }
      else
        format.html { render :edit }
        format.json { render json: @bank_subsidiary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bank_subsidiaries/1
  # DELETE /bank_subsidiaries/1.json
  def destroy
    @bank_subsidiary.destroy
    respond_to do |format|
      format.html { redirect_to bank_subsidiaries_url, notice: 'Bank subsidiary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank_subsidiary
      @bank_subsidiary = BankSubsidiary.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def bank_subsidiary_params
      params.require(:bank_subsidiary).permit(:address, :bank_id)
    end
end
