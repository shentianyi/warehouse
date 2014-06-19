module ApplicationHelper

  def import
    render 'shared/import'
  end

  def search
    @items=model.where(params[@model].clone.delete_if { |k, v| v.length==0 }).paginate(:page => params[:page], :per_page => 20)
    render :index
  end
end
