class PickItemService
  def self.get_order_items user_id, order_ids,filters = nil
    puts "#{order_ids}--------#{user_id}"
    if user=User.find_by_id(user_id)
      if filters
        pick_item_filters=user.pick_item_filters.where(id:filters)
      else
        pick_item_filters=user.pick_item_filters
      end
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
        query=query.where(order_id: order_ids)
        return query
        #.group(:part_id,:whouse_id)
        #.select('order_items.*,sum(order_items.quantity) as quantity')
      end
    end
  end
end