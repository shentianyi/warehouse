class NotificationsController < ApplicationController
  def index
    @bus = OrderService.notify current_user
  end

  def orderbus
    @bus = OrderService.notify current_user
    render partial:'orderbus'
  end
end
