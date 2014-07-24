class PickItemService
  def self.get_order_items user_id, order_ids=nil
    if user=User.find_by_id(user_id)
      pick_item_filters=user.pick_item_filters
      if pick_item_filters.size >0
        query={}
        pick_item_filters.each do |pif|
          key="#{pif.filterable_type.underscore}_id".to_sym
          if query.has_key?(key)
            query[key]=[query[key]] if query[key].is_a?(String)
            query[key]<<pif.filterable_id
          else
            query[key] =pif.filterable_id
          end
        end
      end
      if query
        query= OrderItem.where(query)
        query=query.where(order_id: order_ids) unless order_ids.nil?
        return query.all
      end
    end
    return []
  end

  def self.covert_order_to_pick_list user_id, order_ids=nil
    order_items=get_order_items(user_id, order_ids)
    if order_items.count>0
      pick_list=PickList.new(user_id: user_id)
      order_items.each do |order_item|
        pick_list.pick_items<<PickItem.new(order_item_id: order_item).id
      end
      pick_list.save
      return pick_list
    end
  end
end