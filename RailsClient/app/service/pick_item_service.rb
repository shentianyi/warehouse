class PickItemService
  def self.convert_order_item user_id, order_ids=nil
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
     query=query.where(order_id:order_ids)  unless order_ids.nil?
     return query.all
        end
    end
    return []
  end
end