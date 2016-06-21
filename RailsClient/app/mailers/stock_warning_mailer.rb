class StockWarningMailer < ActionMailer::Base
  default from: "VMI<igoschool@163.com>"

  def stock_warning emails, data
    @data=data
    mail(to: emails, subject: '库存预警')
  end
end
