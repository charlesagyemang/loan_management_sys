class LoansController < ApplicationController
  before_action :set_loan, only: %i[ show edit update destroy ]
  layout 'dashboard'
  before_action :authenticate_user!

  # GET /loans or /loans.json
  def index
    @loans = Loan.order(created_at: :desc)
  end

  # GET /loans/1 or /loans/1.json
  def show
    redirect_to "/", notice: "You have no business here" unless params_exists?
    @loaner = Loaner.find(params[:loaner])
    @all_individual_loans = Loan.where(loaner_id: params[:loaner]).order(created_at: :desc)
  end

  # GET /loans/new
  def new
    redirect_to "/", notice: "You have no business here" unless params_exists?
    @loan = Loan.new
    @loaner = Loaner.find(params[:loaner])
    @all_individual_loans = Loan.where(loaner_id: params[:loaner]).order(created_at: :desc)
  end

  # GET /loans/1/edit
  def edit
  end

  # POST /loans or /loans.json
  def create
    @loan = Loan.new(loan_params)


    respond_to do |format|
      if @loan.save
        NewLoanAlertJob.perform_later(@loan) if Rails.env.production?
        format.html do
          redirect_to "/loans/#{@loan.id}?loaner=#{@loan.loaner_id}", notice: "Loan was successfully created."
        end
        format.json { render :show, status: :created, location: @loan }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loans/1 or /loans/1.json
  def update
    respond_to do |format|
      if @loan.update(loan_params)
        format.html { redirect_to @loan, notice: "Loan was successfully updated." }
        format.json { render :show, status: :ok, location: @loan }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loans/1 or /loans/1.json
  def destroy
    @loan.destroy
    respond_to do |format|
      format.html { redirect_to loans_url, notice: "Loan was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def new_loan_alert
    loan = Loan.find(params[:loan_id])
    NewLoanAlertJob.perform_later(loan) if Rails.env.production?
    redirect_to "/loans/new?loaner=#{loan.loaner.id}", notice: '                                         *********************************************        Message Resent successfully'
  end
  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan
      @loan = Loan.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def loan_params
      params.require(:loan).permit(:principal, :date_payment_starts, :date_loan_given, :interest_on_loan_per_month, :loan_period_in_months, :payment_cadence, :payment_day, :loaner_id, :status)
    end

    def params_exists?
      params["loaner"] && params["loaner"].length > 0
    end
end