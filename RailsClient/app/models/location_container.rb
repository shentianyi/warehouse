class LocationContainer < ActiveRecord::Base
  self.inheritance_column = nil
  include Extensions::UUID
  include CZ::Movable
  include CZ::State

  has_ancestry
  belongs_to :container
  belongs_to :current_positionable, polymorphic: true

  # has_ancestry
  # acts_as_tree
  before_create :init_container_attr

  def init_container_attr
    self.type=LocationContainerType.get_type(self.class.name.sub(/Container/, ''))
  end

  # add child
  def add(child)
    begin
      ActiveRecord::Base.transaction do
        if child.root?
          child.descendants.each do |c|
            c.update_attribute :ancestry, "#{self.child_ancestry}/#{c.ancestor_str}"
          end
          child.update_attribute :parent, self
        end
      end
    rescue Exception => e
      puts e.message
      return false
    end
    true
  end

  # # remove from parent
  def remove
    begin
      ActiveRecord::Base.transaction do
        unless self.root?
          regex=Regexp.new("#{self.ancestor_str}/")
          self.descendants.each do |c|
            c.update_attribute :ancestry, c.ancestor_str.sub(regex, '')
          end
          self.update_attribute :parent, nil
        end
      end
    rescue Exception => e
      puts e.message
      return false
    end
    true
  end

  def add_by_ids(ids)
    begin
      ActiveRecord::Base.transaction do
        ids.each do |id|
          add(self.class.build(id, self.user_id, self.source_location_id))
        end
      end
    rescue Exception => e
      puts e.message
      return false
    end
    true
  end


  def self.destroy_by_container_id(container_id)
    where(container_id: container_id).update_all(is_delete: true, is_dirty: true, ancestry: nil)
  end

end