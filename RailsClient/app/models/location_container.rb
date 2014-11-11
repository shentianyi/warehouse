class LocationContainer < ActiveRecord::Base
  include Extensions::UUID
  include Movable

  has_ancestry
  # acts_as_tree
  belongs_to :container
  belongs_to :current_positionable, polymorphic: true
  belongs_to :sourceable, polymorphic: true
  belongs_to :destinationable, polymorphic: true

  belongs_to :location

  has_many :movable_records, :as => :movable

  def add(child)
      child.descendants.each do |c|
        new_ancestor="#{self.child_ancestry}/#{c.ancestor_str}"
puts new_ancestor
        puts '-----------------------------------'
        puts  c.instance_variable_set('@ancestry', new_ancestor)
        puts c.ancestry=new_ancestor
        puts c.ancestry
       puts c.save
        puts c.errors.full_messages
        puts '***************************8'

      # child.update_attribute :parent, self
    end
  end

  # def add(lc)
  #   if lc.root? && !self.descendant_ids.include?(lc.id)
  #     # self.add_child(lc)
  #     #lc.update_attribute :parent, self
  #     self.add_child(lc)
  #   end
  # end

  def self.exists?(container_id, user_id, location_id)
    c=Container.exists?(container_id)
    return false unless c.nil?
    if lc=self.find_latest_by_container_id(container_id)
      if lc.location_id.equal?(location_id)
        # do rebuild
      else
        new_lc= LocationContainer.create(container_id: child.container_id, user_id: user_id, location_id: location_id, parent: parent)
        lc.rebuild_by_location(user_id, location_id, new_lc)
        # lc.update_attribute
      end
    end
  end

  def rebuild_by_location(user_id, location_id, parent)
    self.children.each do |child|
      if lc=LocationContainer.find_latest(child.container_id, location_id)
        lc.update_attribute :parent, parent if lc.can_rebuild?
      else
        new_lc= LocationContainer.create(container_id: child.container_id, user_id: user_id, location_id: location_id, parent: parent)
        child.rebuild_by_location(user_id, location_id, new_lc)
      end
    end
  end


  def self.find_latest_by_container_id(container_id)
    self.where(container_id: container_id).order(created_at: :desc).first
  end

  def self.find_latest(container_id, location_id)
    self.where(container_id: container_id, location_id: location_id).order(created_at: :desc).first
  end

# state can rebuild
  def can_rebuild?
    true
  end

  def self.destroy_by_container_id(container_id)
    self.where(container_id: container_id).update_all(is_delete: true, is_dirty: true, ancestry: nil)
  end

end