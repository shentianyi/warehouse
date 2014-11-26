class LogisticsContainersController < ApplicationController

  #在查询时，要做join，针对不同的model,packages,forklifts,deliveries.
  #LogisticsContainer,joins(:container)
  #*2014-11-26 需要重写这段代码，太冗余了。
  def search
    @condition=params[:logistics_container]
    @container_condition = params[:container]
    model = params[:model]
    query = LogisticsContainer.joins(model.to_sym)
    @condition.each do |k, v|
      if (v.is_a?(Fixnum) || v.is_a?(String)) && !v.blank?
        if @condition.has_key?(k+'_fuzzy')
          query=query.where("#{k} like ?", "%#{v}%")
        else
          query=query.where(Hash[k, v])
        end
        instance_variable_set("@#{k}", v)
      end
      if v.is_a?(Hash) && v.values.count==2 && v.values.uniq!=['']
        values=v.values.sort
        values[0]=Time.parse(values[0]).utc.to_s if values[0].is_date?
        values[1]=Time.parse(values[1]).utc.to_s if values[1].is_date?
        query=query.where(Hash[k, (values[0]..values[1])])
        v.each do |kk, vv|
          instance_variable_set("@#{k}_#{kk}", vv)
        end
      end
    end

    container_query_condition = {}
    @container_condition.each do |k,v|
      if(v.is_a?(Fixnum)) || v.is_a?(String) && !v.blank?
        puts @container_condition.has_key?(k+'_fuzzy')
        if @container_condition.has_key?(k+'_fuzzy')
          query=query.where("containers.#{k} like ?","%#{v}%")
        else
          container_query_condition[:containers] = Hash[k,v]
        end
        instance_variable_set("@container_#{k}", v)
      end

      if v.is_a?(Hash) && v.values.count==2 && v.values.uniq!=['']
        values=v.values.sort
        values[0]=Time.parse(values[0]).utc.to_s if values[0].is_date?
        values[1]=Time.parse(values[1]).utc.to_s if values[1].is_date?
        container_query_condition[:containers] = Hash[k,(values[0]..values[2])]
        v.each do |kk, vv|
          instance_variable_set("@container_#{k}_#{kk}", vv)
        end
      end
    end
    query=query.where(container_query_condition)

    instance_variable_set("@#{model.pluralize}", query.paginate(:page => params[:page]).all)
    render "#{model.pluralize}/index"
    #render :json => 1#instance_variable_get("@#{model.pluralize}").count
  end
end
