class PickListPresenter<Presenter
  Delegators=[:id, :user_id, :created_at]
  def_delegators :@pick_list, *Delegators

  def initialize(pick_list)
    @pick_list = pick_list
    self.delegators = Delegators
  end

  def user_nr
    @pick_list.user.nil? ? '' : @pick_list.user.nr
  end

  def created_at
    @pick_list.created_at.blank? ? '' : @pick_list.created_at.localtime.strftime('%Y-%m-%d %H:%M')
  end


  def to_json
    {
        id: @pick_list.id,
        user_nr: self.user_nr,
        user_id: self.user_id,
        remark: @pick_list.remark.blank? ? '' : @pick_list.remark,
        created_at: self.created_at
    }
  end
end