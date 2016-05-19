class KskResultState

  # Material 原材料库
  MATERIAL_ADD = 10
  MATERIAL_MOVE_FROM_RECEIVE = 20
  # SemiFinished 半成品库
  SEMIFINISHED_ADD = 30
  SEMIFINISHED_MOVE_FROM_RECEIVE = 40
  SEMIFINISHED_MOVE_FROM_MATERIAL = 41
  #Finished 成品库
  FINISHED_ADD = 50
  FINISHED_MOVE_FROM_MATERIAL = 60
  FINISHED_MOVE_FROM_SEMI = 61
  #Scrap 报废库
  SCRAP_ADD_FROM_MATERIAL = 70
  SCRAP_ADD_FROM_SEMI = 71
  SCRAP_ADD_FINISHED = 72
  SCRAP_MOVE = 80
  #Rework 不良品库
  REWORK_ADD_FROM_RECEIVE = 90
  REWORK_ADD_FROM_MATERIAL = 91
  REWORK_ADD_FROM_SEMI = 92
  REWORK_ADD_FROM_FINISHED = 93
  REWORK_MOVE = 100

  def self.decode_destination(state)
    case state
      when MATERIAL_ADD
        'Material'
      when MATERIAL_MOVE_FROM_RECEIVE
        'Material'
      when SEMIFINISHED_ADD
        'SemiFinished'
      when SEMIFINISHED_MOVE_FROM_RECEIVE
        'SemiFinished'
      when SEMIFINISHED_MOVE_FROM_MATERIAL
        'SemiFinished'
      when FINISHED_ADD
        'Finished'
      when FINISHED_MOVE_FROM_MATERIAL
        'Finished'
      when FINISHED_MOVE_FROM_SEMI
        'Finished'
      when SCRAP_ADD_FROM_MATERIAL
        'Scrap'
      when SCRAP_ADD_FROM_SEMI
        'Scrap'
      when SCRAP_ADD_FINISHED
        'Scrap'
      when SCRAP_MOVE
        'Scrap'
      when REWORK_ADD_FROM_RECEIVE
        'Rework'
      when REWORK_ADD_FROM_MATERIAL
        'Rework'
      when REWORK_ADD_FROM_SEMI
        'Rework'
      when REWORK_ADD_FROM_FINISHED
        'Rework'
      when REWORK_MOVE
        'Rework'
      else
        '未知'
    end
  end

  def self.decode_source(state)
    case state
      # when MATERIAL_ADD
      #   'Material'
      when MATERIAL_MOVE_FROM_RECEIVE
        'WXReceive'
      # when SEMIFINISHED_ADD
      #   'SemiFinished'
      when SEMIFINISHED_MOVE_FROM_RECEIVE
        'WXReceive'
      when SEMIFINISHED_MOVE_FROM_MATERIAL
        'Material'
      # when FINISHED_ADD
      #   'Finished'
      when FINISHED_MOVE_FROM_MATERIAL
        'Material'
      when FINISHED_MOVE_FROM_SEMI
        'SemiFinished'
      when SCRAP_ADD_FROM_MATERIAL
        'Material'
      when SCRAP_ADD_FROM_SEMI
        'SemiFinished'
      when SCRAP_ADD_FINISHED
        'Finished'
      when SCRAP_MOVE
        'Scrap'
      when REWORK_ADD_FROM_RECEIVE
        'WXReceive'
      when REWORK_ADD_FROM_MATERIAL
        'Material'
      when REWORK_ADD_FROM_SEMI
        'SemiFinished'
      when REWORK_ADD_FROM_FINISHED
        'Finished'
      when REWORK_MOVE
        'Rework'
      else
        '未知'
    end
  end
end