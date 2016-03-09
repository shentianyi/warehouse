class LogisticsContainer<LocationContainer
  include CZ::Containable
  include CZ::Movable
  include CZ::Recordable
  include CZ::Service

  alias_method :movable_state_display, :state_display
  after_update :enter_store


  default_scope { where(type: LocationContainerType::LOGISTICS) }
  has_ancestry

  belongs_to :package, foreign_key: :container_id
  has_many :positions, through: :package
  belongs_to :forklift, foreign_key: :container_id
  belongs_to :delivery, foreign_key: :container_id
  has_many :records, :as => :recordable, dependent: :destroy

  after_update :out_store

  # def destroy
  #    self.package.destroy
  # end

  def exists?(location_id)
    self.source_location_id==location_id
  end

  def get_service
    case self.container.type
      when ContainerType::PACKAGE
        self.get_package_service
      when ContainerType::FORKLIFT
        self.get_forklift_service
      when ContainerType::DELIVERY
        self.get_delivery_service
    end
  end

  def presenter
    get_presenter.new(self)
  end

  def get_presenter
    case self.container.type
      when ContainerType::PACKAGE
        self.get_package_presenter
      when ContainerType::FORKLIFT
        self.get_forklift_presenter
      when ContainerType::DELIVERY
        self.get_delivery_presenter
    end
  end


  def add_by_ids(ids)
    begin
      ActiveRecord::Base.transaction do
        ids.each do |id|
          add(self.class.build(id, self.user_id, self.source_location_id))
        end
      end
    rescue Exception => e
      puts e.message
      return false
    end
    true
  end

  def self.build(container_id, user_id, location_id)
    old_lc=self.find_latest_by_container_id(container_id)
    unless old_lc.nil? || old_lc.exists?(location_id)
      new_lc=self.create(container_id: container_id, user_id: user_id, source_location_id: location_id)
      old_lc.rebuild_to_location(user_id, location_id, new_lc)
      return new_lc
    end
    return old_lc
  end

  def rebuild_to_location(user_id, location_id, parent)
    self.children.each do |lc|
      new_lc=self.class.find_latest_by_container_id(lc.container_id)
      unless new_lc.exists?(location_id)
        new_lc=self.class.create(container_id: lc.container_id, user_id: user_id, source_location_id: location_id)
      end
      if new_lc.root?
        parent.add(new_lc)
        lc.rebuild_to_location(user_id, location_id, new_lc)
      end
    end
  end

  def self.find_latest_by_container_id(container_id)
    where(container_id: container_id).order(created_at: :desc).first
  end

  def self.find_latest(container_id, location_id)
    where(container_id: container_id, source_location_id: location_id, state: INIT).order(created_at: :desc).first
  end

  def self.are_roots?(container_ids, location_id)
    where(container_id: container_ids, source_location_id: location_id, ancestry: nil).count==container_ids.length
  end

  def can_add_to_container?
    root?
  end

  # 重寫了Movable::state_display
  # movable_state_display 重新調用了Movable::state_display
  def state_display
    if self.state == MovableState::CHECKED && (LogisticsContainerService.get_all_packages(self).count > LogisticsContainerService.get_all_accepted_packages(self).count)
      "部分接收 | #{update_info}"
    else
      "#{movable_state_display} | #{update_info}"
    end
  end

  def out_store
    begin
      if self.state==MovableState::WAY && self.container.is_package?
        StoreContainer.out_store_by_container(container, self.source_location_id)
      end
      # rescue Exception=>e
      #   puts e.message
      #   false
    end
  end

  def enter_store
    if self.container.type==ContainerType::PACKAGE && self.state_changed?
      begin
        enter_stock
      rescue

      end
    end
  end

  def enter_stock
    if self.state==MovableState::CHECKED
      if (package=self.package)
        # toWh='3EX'
        # if self.destinationable && self.destinationable_type == Whouse.to_s
        #   toWh=self.destinationable_id
        # end
        # params={
        #     partNr: package.part_id,
        #     qty: package.quantity,
        #     fifo: package.parsed_fifo,
        #     packageId: package.id,
        #     toWh: toWh,
        #     uniq: true
        # }
        # if position=PartService.get_position_by_whouse_id(package.part_id, self.destinationable_id)
        #   params[:toPosition]=position.detail
        # else
        #   params[:toPosition]='00 00 00'
        # end

        #用于 leoni 收集数据
        p package
        toWh='WE87'
        if package.logistics_containers.first.parent.blank?
          to_position='WE87-1'
        else
          to_position='WE87-2'
        end
        params={
            partNr: package.part_id,
            qty: package.quantity,
            fifo: package.parsed_fifo,
            packageId: package.id,
            toWh: toWh,
            toPosition: to_position,
            uniq: true
        }
        StorageOperationRecord.save_record(params, 'ENTRY')
        WhouseService.new.enter_stock(params)
      end
    end
  end
end