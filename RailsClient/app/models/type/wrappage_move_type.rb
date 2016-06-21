class WrappageMoveType<BaseType
  ENTER_FROM_SH=100
  ENTER_FROM_CZ=200
  SEND_TO_SH = 300
  BACK_FROM_SH=400
  BACK_TO_CZ = 500

  def self.display v
    case v
      when ENTER_FROM_SH
        '上海莱尼入库数量'
      when ENTER_FROM_CZ
        '常州莱尼入库数量'
      when SEND_TO_SH
        '发上海莱尼数量'
      when BACK_FROM_SH
        '上海莱尼返回数量'
      when BACK_TO_CZ
        '返回常州莱尼数量'
    end
  end


end