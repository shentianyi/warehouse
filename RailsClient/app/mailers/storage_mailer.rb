class StorageMailer < ActionMailer::Base
  default from: "WMS<zhiding.li@cz-tek.com>"

  def safe_stock_notify_email(emails, data)
    @data=data

    mail to: emails, subject: '库存预警报告'
  end
end
