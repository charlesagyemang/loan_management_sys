class CockpitController < ApplicationController
  layout 'dashboard'

  before_action :authenticate_user!

  def admin
    @loans_count = Loan.count
    @investors_count = Investor.count
    @contributions_count = Contribution.count
    @loan_payments_count = LoanPayment.count
    @investors = Investor.last(10)
    @loaners = Loaner.last(10)
    @loan_amount = Loan.sum(:principal)
    @contributions_amount = Contribution.sum(:amount)
    @contributions_principal = Contribution.sum(:principal)
    @contributions_profit = @contributions_amount - @contributions_principal
    @loan_payment_amount = LoanPayment.sum(:amount)
    @profit = Loan.all.map { |l| l.profit.to_i }.reduce(0, :+)
    @retained_profit = @profit - @contributions_profit
    @contributions_paid = Payout.sum(:amount)
    @contributions_not_paid = @contributions_amount - @contributions_paid
  end

  def user
    @loans = Loan.all.includes(:loan_payments)
  end
end
