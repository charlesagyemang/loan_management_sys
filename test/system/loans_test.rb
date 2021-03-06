require "application_system_test_case"

class LoansTest < ApplicationSystemTestCase
  setup do
    @loan = loans(:one)
  end

  test "visiting the index" do
    visit loans_url
    assert_selector "h1", text: "Loans"
  end

  test "creating a Loan" do
    visit loans_url
    click_on "New Loan"

    fill_in "Date loan given", with: @loan.date_loan_given
    fill_in "Date payment starts", with: @loan.date_payment_starts
    fill_in "Interest on loan per month", with: @loan.interest_on_loan_per_month
    fill_in "Loan period in months", with: @loan.loan_period_in_months
    fill_in "Loaner", with: @loan.loaner_id
    fill_in "Payment cadence", with: @loan.payment_cadence
    fill_in "Payment day", with: @loan.payment_day
    fill_in "Principal", with: @loan.principal
    fill_in "Status", with: @loan.status
    click_on "Create Loan"

    assert_text "Loan was successfully created"
    click_on "Back"
  end

  test "updating a Loan" do
    visit loans_url
    click_on "Edit", match: :first

    fill_in "Date loan given", with: @loan.date_loan_given
    fill_in "Date payment starts", with: @loan.date_payment_starts
    fill_in "Interest on loan per month", with: @loan.interest_on_loan_per_month
    fill_in "Loan period in months", with: @loan.loan_period_in_months
    fill_in "Loaner", with: @loan.loaner_id
    fill_in "Payment cadence", with: @loan.payment_cadence
    fill_in "Payment day", with: @loan.payment_day
    fill_in "Principal", with: @loan.principal
    fill_in "Status", with: @loan.status
    click_on "Update Loan"

    assert_text "Loan was successfully updated"
    click_on "Back"
  end

  test "destroying a Loan" do
    visit loans_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Loan was successfully destroyed"
  end
end
