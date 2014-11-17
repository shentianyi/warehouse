class Record < ActiveRecord::Base
  include Extensions::UUID

  belongs_to :recordable, polymorphic: true

  def self.record(recordable,from,to)

  end

  def self.update_or_create(movable,impl)
    puts movable
    puts impl
    unless mr = self.where({recordable:movable,impl_action: impl["action"]}).first
      self.create({recordable:movable,impl_id:impl['id'],impl_user_type:impl['type'],impl_user:ImplUserType.display(impl['type']),impl_action:impl['action'],impl_time:Time.now})
    else
      mr.update({impl_id:impl['id'],impl_user_type:impl['type'],impl_user:ImplUserType.display(impl['type']),impl_time:Time.now})
    end
  end
end
