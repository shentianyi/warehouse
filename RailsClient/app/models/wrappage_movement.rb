class WrappageMovement < ActiveRecord::Base
  validates_presence_of :package_type_id, :message => "包装物类型不能为空!"
  validates_presence_of :move_date, :message => "日期不能为空!"

  belongs_to :package_type
  belongs_to :user
  has_many :wrappage_movement_items, dependent: :destroy

  def self.auto_create params, dlc=nil
    msg = Message.new(contents: [])
    extra_800_nos=dlc.blank? ? '' : LogisticsContainerService.get_all_packages(dlc).select("location_containers.*, containers.extra_800_no as extra_800_no").pluck(:extra_800_no).uniq.join('/')

    ['pallet', 'nps', 'box', 'wooden'].each do |t|
      unless params[t.to_sym].blank?
        unless pt=PackageType.find_by_nr(t)
          msg.contents<< "#{t.to_sym}包装物类型没有维护"
        end
        unless wm=WrappageMovement.where(move_date: params[:move_date], package_type_id: pt.id).first
          wm=WrappageMovement.new({
                                      move_date: params[:move_date],
                                      package_type_id: pt.id,
                                      user_id: params[:user_id]
                                  })
        end
        item = WrappageMovementItem.new({
                                            qty: params[t.to_sym],
                                            wrappage_move_type_id: params[:type],
                                            extra_800_nos: extra_800_nos,
                                            src_location_id: params[:src_id],
                                            des_location_id: params[:des_id],
                                            user_id: params[:user_id]
                                        })
        item.sourceable = dlc if dlc
        wm.wrappage_movement_items<<item
        wm.save
      end
    end

    unless msg.result=(msg.contents.size==0)
      msg.content=msg.contents.join('/')
    end
    msg
  end
end
