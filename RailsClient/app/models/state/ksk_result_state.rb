class KskResultState

  # Material 原材料库
  MATERIAL_ADD = 10
  MATERIAL_MOVE = 20
  # SemiFinished 半成品库
  SEMIFINISHED_ADD = 30
  SEMIFINISHED_MOVE = 40
  #Finished 成品库
  FINISHED_ADD = 50
  FINISHED_MOVE = 60
  #Scrap 报废库
  SCRAP_ADD = 70
  SCRAP_MOVE = 80
  #Rework 不良品库
  REWORK_ADD = 90
  REWORK_MOVE = 100

  def self.display(state)
    case state
      when MATERIAL_ADD
        'Material'
      when MATERIAL_MOVE
        'Material'
      when SEMIFINISHED_ADD
        'SemiFinished'
      when SEMIFINISHED_MOVE
        'SemiFinished'
      when FINISHED_ADD
        'Finished'
      when FINISHED_MOVE
        'Finished'
      when SCRAP_ADD
        'Scrap'
      when SCRAP_MOVE
        'Scrap'
      when REWORK_ADD
        'Rework'
      when REWORK_MOVE
        'Rework'
      else
        '未知'
    end
  end
end