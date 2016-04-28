class BackPartService

  def self.stock_move id, user
    msg=Message.new(result: true)

    bp=BackPart.find_by_id(id)
    if bp && bp.state==BackPartState::INIT
      if bp.back_part_items.count==0
        msg.result = false
        msg.content = "该退货单尚未导入退货详细，请导入"
        return msg
      end

      move_list = MovementList.create(builder: user.id, name: "#{user.nr}_#{DateTime.now.strftime("%H.%d.%m.%Y")}_Back")
      bp.back_part_items.each do |i|
        i.stock_move(user, move_list.id)
      end
      move_list.update(state: MovementListState::ENDING)
      bp.update(state: BackPartState::ENDING)
      msg.content = "退货单出入库成功"
    else
      msg.result = false
      msg.content = "未找到该退货单或者该退货单已出入库"
    end

    msg
  end
end