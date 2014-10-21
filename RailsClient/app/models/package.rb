class Package < ActiveRecord::Base
  include Extensions::UUID
  include Extensions::STATE

  #belongs_to :forklift, :throuth => :forklift_item
  #has_one :forklift_item, :dependent => :destroy
  has_one :package_position, :dependent => :destroy
  #has_one :position, :through => :package_position
  has_many :state_logs, as: :stateable

  belongs_to :user
  belongs_to :location
  belongs_to :part
  belongs_to :forklift
  delegate :delivery, :to => :forklift

  # when a package is added to the forklift
  # please do this
  #here is code for Leoni
  before_save :set_package_position
  after_save :auto_shelved
  after_save :led_state_change

  #-------------
  # Info Methods
  #-------------
  def f
    self.forklift
  end

  def d
    if self.f.nil?
      nil
    else
      self.f.delivery
    end
  end

  #-------------
  # Instance Methods
  #-------------

  # add_to_forklift
  def add_to_forklift forklift
    self.forklift = forklift
    set_position
    self.save
  end

  def position
    if self.package_position
      self.package_position.position
    end
  end

  # remove_form_forklift
  def remove_from_forklift
    if self.forklift
      ActiveRecord::Base.transaction do
        forklift = self.forklift
        self.forklift = nil
        remove_position
        self.save
        #forklift.sum_packages = forklift.packages.count
        #forklift.save
      end
    end
    true
  end

  def set_position
    if self.forklift_id.nil?
      return true
    end

    if pp = PartPosition.joins(:position).where({part_positions: {part_id: self.part_id}, positions: {whouse_id: self.forklift.whouse_id}}).first
      if self.package_position.nil?
        self.create_package_position(position_id: pp.position_id)
      else
        #self.package_position.position_id = pp.position_id
        #self.package_position.is_delete = false
        self.package_position.update({position_id:pp.position_id})
      end
      #self.package_position.save
    elsif self.package_position
      self.package_position.destroy
    else
      return true
    end
  end

  # remove_position
  def remove_position
    if self.package_position
      self.package_position.destroy
    end
  end

  def get_position
    if self.position
      self.position.detail
    else
      nil
    end
  end


  def led_state_change
    if self.position.nil?
      return
    end
    to_state = -1 #LedLightState::NORMAL

    case self.state
      when PackageState::WAY
        to_state = LedLightState::DELIVERED
      when PackageState::RECEIVED
        to_state = LedLightState::RECEIVED
    end

    if to_state != -1
      LedService.update_led_state_by_position(self.position.detail,to_state)
    end
  end

  private

  def auto_shelved
    #if partnum changed, reset package position
    if self.part_id_changed?
      set_position
    end
  end

  def set_package_position
    case self.state
      when PackageState::ORIGINAL
        p=self.user.location
      when PackageState::WAY
        p=Whouse.find_by_id('TransWhouse')
      when PackageState::RECEIVED
        p=self.position
    end

    if p
      self.positionable_id=p.id
      self.positionable_type=p.class.name
    end

  end

  def self.entry_report condition
    self.joins(:part).joins(forklift: :delivery)
    .where(condition)
    .select("packages.state as state,packages.part_id,COUNT(packages.id) as box_count,SUM(packages.quantity_str) as total,forklifts.whouse_id as whouse_id,deliveries.received_date as rdate,deliveries.receiver_id as receover_id")
    .group("packages.part_id,whouse_id,state").order("whouse_id,rdate DESC")
  end

  def self.removal_report condition
    self.joins(:part).joins(forklift: :delivery)
    .where(condition)
    .select("packages.state,packages.part_id,COUNT(packages.id) as box_count,SUM(packages.quantity_str) as total,forklifts.whouse_id as whouse_id,deliveries.delivery_date as ddate,deliveries.user_id as sender_id")
    .group("packages.part_id,whouse_id,state").order("whouse_id,ddate DESC")
  end

  def self.generate_report_condition type,tstart,tend,location_id
    time_range = Time.parse(tstart).utc..Time.parse(tend).utc
    condition = {}
    case type.to_i
      when ReportType::Entry
        condition["deliveries.destination_id"] = location_id
        condition["deliveries.received_date"] = time_range
        condition["deliveries.state"] = [DeliveryState::WAY,DeliveryState::DESTINATION,DeliveryState::RECEIVED]
      when ReportType::Removal
        condition["deliveries.source_id"] = location_id
        condition["deliveries.delivery_date"] = time_range
        condition["deliveries.state"] = [DeliveryState::WAY,DeliveryState::DESTINATION,DeliveryState::RECEIVED]
      when ReportType::Discrepancy
        condition["deliveries.destination_id"] = location_id
        condition["deliveries.received_date"] = time_range
        condition["packages.state"] = [PackageState::RECEIVED]
      else
    end

    return condition
  end

  def self.search condition
    self.joins(:part).joins(forklift: :delivery)
    .where(condition)
    .select("packages.state as state,packages.part_id,COUNT(packages.id) as box_count,SUM(packages.quantity_str) as total,forklifts.whouse_id as whouse_id")
    .group("packages.part_id,whouse_id,state").order("whouse_id DESC")
  end

  def self.export_to_csv packages
    CSV.generate do |csv|

      csv << headers

      packages.each_with_index do |p,index|
        csv << [
            index+1,
            p.part_id,
            p.whouse_id,
            p.total,
            p.box_count,
            PackageState.display(p.state)
        ]
      end
    end
  end

  def self.export_to_xlsx packages
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name=>"sheet1") do |sheet|
      sheet.add_row headers
      packages.each_with_index {|p,index|
        sheet.add_row [
                       index+1,
                       p.part_id,
                       p.whouse_id,
                       p.total,
                       p.box_count,
                       PackageState.display(p.state)
                      ]
      }
    end
    p.to_stream.read
  end

  def self.to_xlsx packages
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name=>"sheet1") do |sheet|
      sheet.add_row ["序号","编号","零件号","数量","状态","备货员工","所属托盘","托盘状态","备货部门","所属运单","运单状态","接收时间","上加库位"]
      packages.each_with_index {|package,index|
        sheet.add_row [
                          index+1,
                          package.id,
                          package.part_id,
                          package.quantity_str,
                          PackageState.display(package.state),
                          package.user_id ?  package.user.name+"|"+package.user_id : "",
                          package.forklift ? package.forklift_id : "",
                          package.forklift ? ForkliftState.display(package.forklift.state) : "",
                          package.forklift ? package.forklift.whouse_id : "",
                          package.d ? package.d.id : "",
                          package.d ? DeliveryState.display(package.d.state) : "",
                          (package.d && package.d.received_date) ?  package.d.received_date.localtime.strftime('%Y-%m-%d %H:%M:%S') : "",
                          package.position ? package.position.whouse.name + ' ' +package.position.detail : ""
                      ]
      }
    end
    p.to_stream.read
  end

  private
  def self.headers
    ["No.","Part Nr.","BU","Quantity","Package Num","State"]
  end
end
