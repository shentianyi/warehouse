class PickItemFilter < ActiveRecord::Base
  include Extensions::UUID
  include Import::PickItemFilterCsv
  belongs_to :user
  belongs_to :filterable, polymorphic: true

  validate :validate_save

                  @@filter_types={
                      PartType:{name:'PartType',display:'零件类型'},
                      Whouse:{name:'Whouse',display:'项 目'}
                  }

  def self.filter_types
    @@filter_types
  end

  def filter_type_display
    @@filter_types[self.filterable_type.to_sym][:display]
  end

  private
  def validate_save
    if user= User.find_by_id(self.user_id)
      if filterable=self.filterable_type.constantize.find_by_id(self.filterable_id)
        if self.filterable_type=='Whouse'
          errors.add(:filterable_id,'接收仓库不存在') unless user.location.destination.whouses.where(id:self.filterable_id).count>0
        end
      else
        errors.add(:filterable_id,'筛选值不存在')
      end
    else
      errors.add(:user_id,'员工号不存在')
    end
  end
end
