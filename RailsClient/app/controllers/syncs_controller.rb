class SyncsController < ApplicationController
  skip_before_filter :configure_permitted_parameters
   skip_before_filter :authenticate_user_from_token!
  #skip_before_filter :authenticate_user!

  def index
    @host=Sync::Config.host
    @token=Sync::Config.token
    @sync_lock=Sync::Config.sync_lock
    @lock=Sync::Config.lock
    @enabled=Sync::Config.enabled
    @advance_second=Sync::Config.advance_second
    @per_request_size=Sync::Config.per_request_size
    @last_time=Sync::Config.last_time
    @executors=Sync::Executor.all
  end

  def update
    msg=Message.new(result: true)
    if params[:id]=='basic'
      Sync::Config.host=params[:config][:host]
      Sync::Config.token =params[:config][:token]
      Sync::Config.sync_lock =params[:config][:sync_lock]== 'true'
      Sync::Config.lock = params[:config][:lock] == 'true'
      Sync::Config.enabled=params[:config][:enabled] == 'true'
      Sync::Config.advance_second =params[:config][:advance_second].to_i
      Sync::Config.per_request_size=  params[:config][:per_request_size].to_i
      Sync::Config.save

      if Sync::Config.lock
        SyncLog.where(sync: false).all.each do |t|
          model = t.table_name.singularize.classify.constantize
          Sync::Config.reset_callbacks(model)
        end
      end

    elsif params[:id]=='sync'
      Sync::Config.last_time =params[:config][:last_time]
      Sync::BaseSync.execute
      msg.content = Sync::Config.last_time
    elsif params[:id]=='exe'
      params[:config].each do |k, v|
        v.each { |kk, vv| v[kk]=(vv=='true') }
        if ex=Sync::Executor.find(k)
          ex.update(v)
        end
      end
      Sync::Config.save
    end
    render json: msg
  end

  def reload
    Sync::Config.reload
    redirect_to action: :index
  end

end