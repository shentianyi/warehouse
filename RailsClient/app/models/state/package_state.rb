class PackageState<BaseState
  RECEIVED=3
  REJECTED=4

  def self.display state
    case state
      when RECEIVED
        '已接收'
      when
        REJECTED
        '拒收'
      else
        super
    end
  end
end