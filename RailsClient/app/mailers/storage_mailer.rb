class StorageMailer < ActionMailer::Base
  # default from: "WMS<zhuzhiming@jiaxuanwl.com>"
  # default from: "WMS<zhiding.li@cz-tek.com>"

  def safe_stock_notify_email(emails, data)
    @data=data

    # mail to: emails, subject: '库存预警报告'

    mail( :to       => emails,
          :from     => 'WMS<zhuzhiming@jiaxuanwl.com>',
          :subject  => '库存预警报告')
  end
end