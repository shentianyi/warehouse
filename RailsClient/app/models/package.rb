class Package<Container
  default_scope { where(type: ContainerType::Package) }

  def self.id_valid?(id)
    Package.unscoped.where(id: id, type: ContainerType::Package).first.nil?
  end

  def self.exists?(id)
    self.find_by_id(id)
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


  alias_method :check_in_time=, :custom_fifo_time=
  alias_method :check_in_time, :custom_fifo_time
  alias_method :quantity_str=, :custom_quantity=
  alias_method :quantity_str, :custom_quantity
end