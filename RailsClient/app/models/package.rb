class Package<Container

  has_many :part_positions, through: :part
  has_many :positions, through: :part

  default_scope { where(type: ContainerType::PACKAGE) }

  def self.id_valid?(id)
    Package.unscoped.where(id: id, type: ContainerType::Package).first.nil?
  end

  def custom_fifo_time=(value)
    @custom_fifo_time = value
    self.fifo_time=Date.strptime(@custom_fifo_time, '%d.%m.%y') unless @custom_fifo_time.nil?
  end

  def custom_fifo_time
    @custom_fifo_time || (self.fifo_time.strftime('%d.%m.%y') unless self.fifo_time.nil?)
  end

  def custom_quantity=(value)
    @custom_quantity=value
    self.quantity=@custom_quantity
  end

  def custom_quantity
    self.quantity.to_s
  end

  def self.to_xlsx packages
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["序号", "编号", "零件号", "数量", "状态", "备货员工", "所属托盘", "托盘状态", "备货部门", "所属运单", "运单状态", "接收时间", "上架库位"]
      packages.each_with_index { |package, index|
        if package.id && package.id != ""
          sheet.add_row [
                            index+1,
                            package.id,
                            package.part_id,
                            package.quantity_str,
                            PackageState.display(package.state),
                            package.user_id ? package.user.name+"|"+package.user_id : "",
                            package.forklift ? package.forklift_id : "",
                            package.forklift ? ForkliftState.display(package.forklift.state) : "",
                            package.forklift ? package.forklift.whouse_id : "",
                            package.d ? package.d.id : "",
                            package.d ? DeliveryState.display(package.d.state) : "",
                            (package.d && package.d.received_date) ? package.d.received_date.localtime.strftime('%Y-%m-%d %H:%M:%S') : "",
                            package.position ? package.position.whouse.name + ' ' +package.position.detail : ""
                        ]
        end
      }
    end
    p.to_stream.read
  end

  alias_method :check_in_time=, :custom_fifo_time=
  alias_method :check_in_time, :custom_fifo_time
  alias_method :quantity_str=, :custom_quantity=
  alias_method :quantity_str, :custom_quantity
end
