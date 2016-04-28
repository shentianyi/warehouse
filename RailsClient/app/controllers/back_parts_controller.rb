class BackPartsController < ApplicationController
  before_action :set_back_part, only: [:show, :edit, :update, :destroy, :back_part_items]

  respond_to :html

  def index
    @back_parts = BackPart.order(created_at: :desc).paginate(:page=> params[:page])
    respond_with(@back_parts)
  end

  def show
    respond_with(@back_part)
  end

  def new
    @back_part = BackPart.new
    respond_with(@back_part)
  end

  def edit
  end

  def create
    @back_part = BackPart.new(back_part_params)
    @back_part.save
    respond_with(@back_part)
  end

  def update
    @back_part.update(back_part_params)
    respond_with(@back_part)
  end

  def destroy
    @back_part.destroy
    respond_with(@back_part)
  end

  def back_part_items
    @back_part_items = @back_part.back_part_items.paginate(:page => params[:page])
    @page_start=(params[:page].nil? ? 0 : (params[:page].to_i-1))*20
  end

  def print
    msg=Message.new
    begin
      puts SysConfigCache.print_server_value
      msg= RestClient::Resource.new("#{SysConfigCache.print_server_value}/printer/print/P011/#{params[:id]}",
                                    :timeout => 20,
                                    :open_timeout => 20,
                                    'content_type' => 'application/json').get
    rescue
      msg.result
      msg.content='无法连接打印服务器，请重新配置'
    end
    msg.result =true
    render json: msg
  end

  def search
    super { |query|
      if user=User.find_by_nr(params[:back_part][:user_id])
        query=query.unscope(where: :user_id).where(user_id: user.id)
      end

      query
    }
  end

  # def search
  #   @condition=params[@model]
  #   query=model.all #.unscoped
  #   @condition.each do |k, v|
  #     if (v.is_a?(Fixnum) || v.is_a?(String)) && !v.blank?
  #       puts @condition.has_key?(k+'_fuzzy')
  #       if @condition.has_key?(k+'_fuzzy')
  #         query=query.where("#{k} like ?", "%#{v}%")
  #       else
  #         query=query.where(Hash[k, v])
  #       end
  #       instance_variable_set("@#{k}", v)
  #     end
  #     #if v.is_a?(Array) && !v.empty?
  #     #  query= v.size==1 ? query.where(Hash[k, v[0]]) : query.in(Hash[k, v]
  #     #end
  #     #query=query.where(Hash[k, v]) if v.is_a?(Range)
  #     if v.is_a?(Hash) && v.values.count==2 && v.values.uniq!=['']
  #       values=v.values.sort
  #       values[0]=Time.parse(values[0]).to_s if values[0].is_date? & values[0].include?('-')
  #       values[1]=Time.parse(values[1]).to_s if values[1].is_date? & values[1].include?('-')
  #       query=query.where(Hash[k, (values[0]..values[1])])
  #       v.each do |kk, vv|
  #         instance_variable_set("@#{k}_#{kk}", vv)
  #       end
  #     end
  #   end
  #
  #   if block_given?
  #     query=(yield query)
  #   end
  #
  #   if params.has_key? "download"
  #     send_data(query.to_xlsx(query),
  #               :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet",
  #               :filename => @model.pluralize+".xlsx")
  #     #render :json => query.to_xlsx(query)
  #   else
  #     instance_variable_set("@#{@model.pluralize}", query.paginate(:page => params[:page]).all)
  #     render :index
  #   end
  # end

  def stock_move
    msg=BackPartService.stock_move(params[:id], current_user)

    respond_to do |format|
      format.html { redirect_to back_parts_url, notice: msg.content }
      format.json { head :no_content }
    end
  end

  private
    def set_back_part
      @back_part = BackPart.find(params[:id])
    end

    def back_part_params
      params.require(:back_part).permit(:user_id, :des_location_id, :src_location_id, :state, :back_time)
    end
end
