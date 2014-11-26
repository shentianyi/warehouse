class LogisticsContainersController < ApplicationController

  #在查询时，要做join，针对不同的model,packages,forklifts,deliveries.
  #LogisticsContainer,joins(:container)
  #*2014-11-26 需要重写这段代码，太冗余了。
  #*需要重写,可以join不同的表查询,那么需要注明还要哪些表来进行查询
  def search
    model = params[:model]
    @condition=params[model.to_sym]
    query = LogisticsContainer

    joins = ["location_containers"]
    args  = [model]

    if params[:tables]
      tables = params[:tables].split(';')
      tables.each{|t| query = query.joins(t.to_sym)}
      joins = joins + tables
      args = args + tables
    end

    hash_conditions = {}

    joins.zip(args).each do |table,arg|
      condition = params[arg.to_sym]
      condition.each do |k,v|
        if (v.is_a?(Fixnum) || v.is_a?(String)) && !v.blank?
          if condition.has_key?(k+'_fuzzy')
            query = query.where("#{table.pluralize}.#{k} like ?","%#{v}%")
          else
            hash_conditions[table.to_sym] = Hash[k,v]
          end
          instance_variable_set("@#{arg}_#{k}", v)
        end
        if v.is_a?(Hash) && v.values.count==2 && v.values.uniq!=['']
          values=v.values.sort
          values[0]=Time.parse(values[0]).utc.to_s if values[0].is_date?
          values[1]=Time.parse(values[1]).utc.to_s if values[1].is_date?
          hash_conditions[table.to_sym] = Hash[k,(values[0]..values[1])]
          v.each do |kk, vv|
            instance_variable_set("@#{arg}_#{k}_#{kk}", vv)
          end
        end
      end
    end
    puts "==============="
    puts hash_conditions

    query=query.where(hash_conditions)

    instance_variable_set("@#{model.pluralize}", query.paginate(:page => params[:page]).all)
    render "#{model.pluralize}/index"
    #render :json => 1
  end
end
