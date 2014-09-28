class NotificationsController < ApplicationController
  def index
    @bus = OrderService.notify
  end

  def orderbus
    @bus = OrderService.notify
    render partial:'orderbus'
  end
end
