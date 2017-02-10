class PickItemStatus<BaseStatus
  # BEFORE_INIT=0
  # BEFORE_PRINTING=1
  # BEFORE_PRINTED=2
  INIT = 100
  PICKING = 200
  PICKED = 300
  ABORTED = 400

  def self.display state
    case state
      # when BEFORE_INIT
      #   '新建'
      # when BEFORE_PRINTING
      #   '择货中'
      # when BEFORE_PRINTED
      #   '已择货'
      when INIT
        '新建'
      when PICKING
        '择货中'
      when PICKED
        '已择货'
      else
        '放弃'
    end
  end
end