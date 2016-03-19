module V1
  class OrderItemAPI<Base
    namespace :order_items do
      guard_all!

      #strong parameters
      helpers do
        def order_params
          ActivonController::Parameters.new(params).require(:order_item).permit(:id, :department, :quantity, :part_id, :user_id)
        end
      end

      post :verify do
        p params
        unless part = OrderItemService.verify_part_id(params[:part_id], current_user)
          return {result: 0, error_code: ErrorCode.part.not_exist, content: OrderItemMessage::PartIDError}
        end

        unless location = OrderItemService.verify_location(current_user)
          return {result: 0, error_code: ErrorCode.default, content: OrderItemMessage::OrderLocationError}
        end

        unless quantity = OrderItemService.verify_quantity(params[:quantity])
          return {result: 0, error_code: ErrorCode.default, content: OrderItemMessage::QuantityError}
        end

        unless item = OrderItemService.new( location,part, quantity, false, 0, current_user)
          return {result: 0, error_code: ErrorCode.default, content: OrderItemMessage::VerifyFailed}
        end

        return {result: 1, content: OrderItemPresenter.new(item).to_json}
      end

      delete do
        unless item = OrderItemService.exists?(params[:id])
          return {result: 0, content: OrderItemMessage::NotFound}
        end

        item.destroy
        return {result: 1, content: OrderItemMessage::DeleteSuccess}
      end

      get :detail do
        unless item = OrderItemService.exists?(params[:id])
          return {result: 0, content: OrderItemMessage::NotFound}
        end

        return {result: 1, content: OrderItemPresenter.new(item).to_json}
      end

      put do
        unless item = OrderItemService.exists?(params[:id])
          return {result: 0, content: OrderItemMessage::NotFound}
        end

        unless item = OrderItemService.update(params)
          return {result: 0, content: OrderItemMessage::UpdateFailed}
        end

        return {result: 1, content: 'Item'}
      end
    end
  end
end