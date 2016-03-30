
#encoding: utf-8
class PartPresenter<Presenter
  Delegators=[:id, :nr, :name, :unit_pack, :customernum, :user_id, :part_type_id, :custom_nr, :cross_section, :weight, :weight_range, :is_delete, :convert_unit]
  def_delegators :@part, *Delegators

  def initialize(part)
    @part=part
    self.delegators =Delegators
  end


  def as_basic_info
    if @part.nil?
      nil
    else
      {
          id: @part.id,
          weight:@part.weight||1,
          weight_range:@part.weight_range
      }
    end
  end

end