class OrderMailer < ActionMailer::Base
  default from: 'VMI<igoschool@163.com>'

  def notify recipients, parts
    @parts=parts
    @sh=Tenant.find_by_code('SHL')
    @cz=Tenant.find_by_code('CZL')
    begin
      mail(to: recipients, subject: '库存预警')
    rescue Exception => e
      puts e.message
    end
  end
end
OrderMailer.notify