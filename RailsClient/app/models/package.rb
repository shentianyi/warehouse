class Package<Container
  default_scope { where(type: ContainerType::Package) }


  def custom_fifo_time=(value)
    @custom_fifo_time = value
    self.fifo_time=Date.strptime(self.check_in_time, '%d.%m.%y') unless @custom_fifo_time.nil?
  end

  def custom_fifo_time
    @custom_fifo_time || (self.fifo_time.strftime('%d.%m.%y') unless self.fifo_time.nil?)
  end

  alias_method :check_in_time=, :custom_fifo_time=
  alias_method :check_in_time, :custom_fifo_time
end