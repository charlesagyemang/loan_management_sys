class Loan < ApplicationRecord
  belongs_to :loaner
  has_many :loan_payments, dependent: :destroy
  before_create :set_amount

  def set_amount
    self.amount = interest_on_loan_per_month > 0.00 ? (((loan_period_in_months * interest_on_loan_per_month) / 100) * principal) + principal : principal
  end

  def details
    "#{payment_cadence} Payments @ #{interest_on_loan_per_month}% per month for #{loan_period_in_months} months"
  end

  def loan_summary
    interest = interest_on_loan_per_month * interest_on_loan_per_month
    simple_interest = principal * (interest / 100)
    amount_expected = principal + simple_interest
    total_loan_payments = loan_payments.sum(:amount)

    {
      principal: principal,
      interest_over_the_months: interest,
      simple_interest: simple_interest,
      amount_expected: amount_expected,
      tot_payments_made_so_far: total_loan_payments,
      amount_remaining: amount_expected - total_loan_payments
    }
  end

  def profit
    set_amount - principal
  end
  
end