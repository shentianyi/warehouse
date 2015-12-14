class MovementSourcesController < ApplicationController
  before_action :set_movement_source, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def search
    @condition=params[@model]
    query=MovementSource.joins(:movement_list)
              .select("movement_sources.*, movement_lists.state as state")
              .where("movement_lists.state != #{MovementListState::ENDING}")
    @condition.each do |k, v|
      if (v.is_a?(Fixnum) || v.is_a?(String)) && !v.blank?
        puts @condition.has_key?(k+'_fuzzy')
        if @condition.has_key?(k+'_fuzzy')
          query=query.where("#{k} like ?", "%#{v}%")
        else
          query=query.where(Hash[k, v])
        end
        instance_variable_set("@#{k}", v)
      end
      #if v.is_a?(Array) && !v.empty?
      #  query= v.size==1 ? query.where(Hash[k, v[0]]) : query.in(Hash[k, v]
      #end
      #query=query.where(Hash[k, v]) if v.is_a?(Range)
      if v.is_a?(Hash) && v.values.count==2 && v.values.uniq!=['']
        values=v.values.sort
        values[0]=Time.parse(values[0]).utc.to_s if values[0].is_date? & values[0].include?('-')
        values[1]=Time.parse(values[1]).utc.to_s if values[1].is_date? & values[1].include?('-')
        query=query.where(Hash[k, (values[0]..values[1])])
        v.each do |kk, vv|
          instance_variable_set("@#{k}_#{kk}", vv)
        end
      end
    end

    if params.has_key? "download"
      send_data(query.to_xlsx(query),
                :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
                :filename => @model.pluralize+".xlsx")
      #render :json => query.to_xlsx(query)
    else
      instance_variable_set("@#{@model.pluralize}", query.paginate(:page => params[:page]).all)
      render :index
    end
  end

  def index
    @movement_sources = MovementSource.joins(:movement_list)
                            .select("movement_sources.*, movement_lists.state as state")
                            .where("movement_lists.state != #{MovementListState::ENDING}").paginate(:page => params[:page])
    # @movement_sources = MovementSource.all.paginate(:page => params[:page])
    respond_with(@movement_sources)
  end

  def show
    respond_with(@movement_source)
  end

  def new
    @movement_source = MovementSource.new
    respond_with(@movement_source)
  end

  def edit
  end

  def create
    @movement_source = MovementSource.new(movement_source_params)
    @movement_source.save
    respond_with(@movement_source)
  end

  def update
    @movement_source.update(movement_source_params)
    respond_with(@movement_source)
  end

  def destroy
    @movement_source.destroy
    respond_with(@movement_source)
  end

  private
    def set_movement_source
      @movement_source = MovementSource.find(params[:id])
    end

    def movement_source_params
      params.require(:movement_source).permit(:movement_list_id, :fromWh, :fromPosition, :packageId, :partNr, :qty, :fifo, :toWh, :toPosition, :employee_id, :remarks)
    end
end
