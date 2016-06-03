class StockWarningMailer < ActionMailer::Base
  default from: "from@example.com"

  def stock_warning emails, data
    @data=data

    mail(to: emails, subject: '库存预警')
  end
end
