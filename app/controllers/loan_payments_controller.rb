class LoanPaymentsController < ApplicationController
  before_action :set_loan_payment, only: %i[ show edit update destroy ]
  layout 'dashboard'
  before_action :authenticate_user!
  
  # GET /loan_payments or /loan_payments.json
  def index
    @loan_payments = LoanPayment.includes(:loan, :loaner).order(created_at: :desc)
  end

  # GET /loan_payments/1 or /loan_payments/1.json
  def show
    redirect_to loaners_path, notice: "You are unauthorized to add loan payments please see admin to get this rectified. Thank you" unless params_exists?
    @loan_payments_by_loaner = LoanPayment.where(loan_id: params["loan"], loaner_id: params["loaner"]).order(created_at: :desc)
    @loan = Loan.find(params["loan"])
    @loaner = Loaner.find(params["loaner"])
    @paid = @loan.loan_payments.sum(:amount)
    @remaining = @loan.amount - @paid
  end

  # GET /loan_payments/new
  def new
    redirect_to loaners_path, notice: "You are unauthorized to add loan payments please see admin to get this rectified. Thank you" unless params_exists?
    @loan_payment = LoanPayment.new
    @loan_payments_by_loaner = LoanPayment.where(loan_id: params["loan"], loaner_id: params["loaner"]).order(created_at: :desc)
    @loan = Loan.find(params["loan"])
    @loaner = Loaner.find(params["loaner"])
    @paid = @loan.loan_payments.sum(:amount)
    @remaining = @loan.amount - @paid
  end

  # GET /loan_payments/1/edit
  def edit
  end

  # POST /loan_payments or /loan_payments.json
  def create
    # redirect_to loaners_path, notice: "You are unauthorized to add loan payments please see admin to get this rectified. Thank you" unless params_exists?
    @loan_payment = LoanPayment.new(loan_payment_params)
    respond_to do |format|
      if @loan_payment.save
        SendSmsJob.perform_later(@loan_payment) if ensure_status_is_received && Rails.env.production?
        format.html do
          redirect_to "/loan_payments/#{@loan_payment.id}?loan=#{@loan_payment.loan_id}&loaner=#{@loan_payment.loaner_id}", notice: "Loan payment was successfully created."
        end
        format.json { render :show, status: :created, location: @loan_payment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @loan_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /loan_payments/1 or /loan_payments/1.json
  def updates
    respond_to do |format|
      if @loan_payment.update(loan_payment_params)
        format.html { redirect_to @loan_payment, notice: "Loan payment was successfully updated." }
        format.json { render :show, status: :ok, location: @loan_payment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @loan_payment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loan_payments/1 or /loan_payments/1.json
  def destroy
    @loan_payment.destroy
    respond_to do |format|
      format.html { redirect_to loan_payments_url, notice: "Loan payment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_loan_payment
      @loan_payment = LoanPayment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def loan_payment_params
      params.require(:loan_payment).permit(:loaner_id, :loan_id, :mode, :amount, :status, :next_payment_date)
    end

    def params_exists?
      params["loaner"] && params["loaner"].length > 0 && params["loan"] && params["loan"].length > 0
    end

    def ensure_status_is_received
      @loan_payment.status == 'RECEIVED'
    end
    
end
# heroku addons:create heroku-postgresql:mini --app benjicap --fork postgres://asnnglbqhjeqdi:69e1bfc472b4667df33d29c237678714ed4a7f90d8ea4382c170e44cc611b032@ec2-52-5-110-35.compute-1.amazonaws.com:5432/d140skju2d25to