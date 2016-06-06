class LogisticsContainer<LocationContainer
  include CZ::Containable
  include CZ::Movable
  include CZ::Recordable
  include CZ::Service

  alias_method :movable_state_display, :state_display
  after_update :check_move_stock
  # after_update :check_safe_stock

  #before_create :generate_batch_nr

  default_scope { where(type: LocationContainerType::LOGISTICS) }
  has_ancestry

  belongs_to :package, foreign_key: :container_id
  has_many :positions, through: :package
  belongs_to :forklift, foreign_key: :container_id
  belongs_to :delivery, foreign_key: :container_id
  has_many :records, :as => :recordable, dependent: :destroy
  has_many :wrappage_movement_records, :as => :sourceable, dependent: :destroy

  #after_update :out_store
  after_destroy :destroy_container

  def destroy_container
    if self.container.present?
      self.container.destroy
    end
  end

  # def destroy
  #    self.package.destroy
  # end
  # def generate_batch_nr
  #   start_time=Time.now.beginning_of_day.utc
  #   end_time=Time.now.end_of_day.utc
  #
  #   count= self.class.joins(:delivery)
  #              .where(created_at: [start_time..end_time],
  #                     source_location_id: Location.find_by_nr('SHJXLO').id).count
  #
  #   self.batch_no= "#{Time.now.strftime('%y%m%d')}#{ '%02d' % ((count)*2)}"
  # end

  def self.last_lc_container container_id
    where(container_id: container_id).order('created_at desc').first
  end

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

  def batch_nr
    case self.container.type
      when ContainerType::FORKLIFT
        if self.parent
          self.parent.batch_nr
        end
      when ContainerType::DELIVERY
        self.order.blank? ? '' : self.order.batch_nr
      else
        ''
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
    if self.state == MovableState::CHECKED && (LogisticsContainerService.get_all_packages(self).count > LogisticsContainerService.get_all_accepted_packages(self).count) && (LogisticsContainerService.get_all_accepted_packages(self).count>0)
      '部分接收'
    else
      movable_state_display
    end
  end

  def check_move_stock
    puts '----------------------------------------------------------------------------------------------------------------------------------'
    if (package=self.package)
      source_location=self.source_location
      destinationable=self.destinationable
      if self.state==MovableState::CHECKED
        begin
          if NStorage.where(ware_house_id: source_location.send_whouse.id, packageId: package.id).first
            WhouseService.new.move({
                                       partNr: package.part.id,
                                       qty: package.quantity,
                                       packageId: package.id,
                                       fromWh: source_location.send_whouse.id,
                                       toWh: destinationable.receive_whouse.id,
                                       toPosition: destinationable.receive_whouse.default_position.id,
                                       employee_id: package.user.blank? ? '' : package.user.nr
                                   })
          end
        rescue
        end
      elsif (self.state==MovableState::REJECTED && self.state_was==MovableState::CHECKED)
        begin
          if NStorage.where(ware_house_id: destinationable.receive_whouse.id, packageId: package.id).first
            WhouseService.new.move({
                                       partNr: package.part.id,
                                       qty: package.quantity,
                                       packageId: package.id,
                                       fromWh: destinationable.receive_whouse.id,
                                       toWh: source_location.send_whouse.id,
                                       toPosition: source_location.send_whouse.default_position.id,
                                       employee_id: package.user.blank? ? '' : package.user.nr
                                   })
          end
        rescue
        end
      elsif (self.state==MovableState::WAY && self.state_was==MovableState::INIT)
        # begin
        if ns= NStorage.where(packageId: package.id).first
          WhouseService.new.move({
                                     partNr: package.part.id,
                                     qty: package.quantity,
                                     packageId: package.id,
                                     fromWh: ns.ware_house_id,
                                     toWh: source_location.send_whouse.id,
                                     toPosition: source_location.send_whouse.default_position.id,
                                     employee_id: package.user.blank? ? '' : package.user.nr
                                 })
        else
          self.enter_stock(source_location.send_whouse, source_location.send_whouse.default_position, Time.now)
        end
        # rescue
        #
        # end
      end
    end
  end

  def enter_stock(warehouse, position, fifo)
    # if self.state==MovableState::CHECKED
    if (package=self.package)
      params={
          partNr: package.part.id,
          qty: package.quantity,
          fifo: fifo,
          packageId: package.id,
          toWh: warehouse.id,
          toPosition: position.id,
          employee_id: package.user_id
      }
      WhouseService.new.enter_stock(params)
    end
    # end
  end


  def check_safe_stock

    # if self.source_location.is_open_safe_qty
    #   if delivery = self.delivery
    #     if self.state_was==MovableState::INIT && self.state==MovableState::WAY
    #
    #       emails=self.source_location.safe_qty_emails.split(',')
    #       if emails.count>0
    #         packages= LogisticsContainerService.get_packages(self)
    #         if packages.count>0
    #           parts=[]
    #
    #           packages.each do |pack|
    #             part=pack.package.part
    #             part_count=NStorage.where(partNr: part.id,
    #                                       ware_house_id: (self.source_location.whouses.pluck(:id)-[self.source_location.send_whouse.id])).count
    #             if part_count<=part.safe_qty
    #               parts<<part
    #             end
    #           end
    #           if parts.count>0
    #             OrderMailer.notify(emails, parts).deliver
    #           end
    #         end
    #       end
    #     end
    #   end
    #
    #
    # end
  end

  def part_type_count
    return @part_type_count if @part_type_count
    @part_type_count={
        wooden: 0,
        box: 0,
        nps: 0
    }
    PackageType.all.each do |t|
      @part_type_count[t.nr.to_sym] =LogisticsContainerService.get_packages(self).joins(package: :part).where(parts: {package_type_id: t.id}).count
    end
    @part_type_count
  end
end