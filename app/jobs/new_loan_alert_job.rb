class NewLoanAlertJob < ApplicationJob
  queue_as :default

  
  def perform(loan)
    # send_sms(to, message)
    dixy = {
      'WEEKLY' => 4,
      'BI_WEEKLY' => 2,
      'MONTHLY' => 1
    }
    cadence_duration = dixy[loan.payment_cadence].to_i * loan.loan_period_in_months.to_i
    cadence_payments = loan.amount / cadence_duration
    phone_number = loan.loaner.phone_number
    message = "Hi #{loan.loaner.first_name} #{loan.loaner.last_name}, Congratulations!!, NBKFund has approved your loan request of GHC #{loan.principal} with a #{loan.interest_on_loan_per_month}%/m interest for a period for #{loan.loan_period_in_months} months. You are expected to make a #{loan.payment_cadence} payment of GHC #{cadence_payments}. Your first payment is expected on #{loan.date_payment_starts.to_formatted_s(:long)}. You are expected to finish paying off in #{cadence_duration} #{loan.payment_cadence} cycles. Please contact Mr Benjamin for more details. Thank you"
    puts "============ MESSAGES #{message} ====================="
    puts "============ PhoneNumber #{phone_number} ====================="
    send_sms(phone_number, message)
    send_sms('0507565349', message)
    send_sms('0241763680', message)
    puts '*************MESSAGE*****************', message
  end

  private
    def send_sms(to, message)
      client = WITTLY_FLOW_CLIENT
      res = client.send_sms('NBKFund', to, message)
      puts "============ SENDING SMS TO #{to} SMS LOGS: #{message} ====================="
      puts "============ SMS LOGS: #{res} ====================="
    end
end
