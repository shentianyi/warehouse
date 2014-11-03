require_relative 'gen.rb'

class ContainerType
  Package=1
  Forklift=2
  Delivery=3

  def self.get_type(type)
    self.const_get(type)
  end
end

class Container
  attr_accessor :id, :type, :creator, :name
  attr_accessor :children, :parent, :ancestors
  # has many container_goods

  #liqi
  #add current action to Container
  attr_accessor :action
  @@containers={}

  def initialize(args={})
    self.id=Gen.get_container_id
    self.creator = rand(100)
    args.each do |k, v|
      self.instance_variable_set("@#{k}", v) unless v.nil?
    end
    self.type=ContainerType.get_type(self.class.name)
  end

  def create
    @@containers[self.id]=self
    self
  end

  def all
    @@containers.values
  end

  def add(child)
    if child.is_root? && !self.has_child?(child)
      self.add_child(child)
    end
  end

  def is_root?
    self.parent.nil?
  end

  def has_parent?
    !is_root?
  end

  def has_children?
    !self.children.nil?
  end

  def has_child?(child)
    return false if self.children.nil?
    self.children.values.each do |c|
      return true if c.id==child.id
      return c.has_child?(child)
    end
  end

  def has_ancestor?(ancestor)
    !self.ancestors[ancestor.id].nil?
  end

  protected
  def add_child(child)
    self.children ={} if self.children.nil?
    self.children[child.id]=child
    child.parent=self
    child.ancestors={} if child.ancestors.nil?
    child.ancestors[self.id]=self
    self.prev_children_ancestor
  end

  def prev_children_ancestor
    if self.has_children?
      self.children.values.each do |c|
        # c.ancestors={} if c.ancestors.nil?
        self.ancestors.values.each do |a|
          c.ancestors[a.id]=a
        end unless self.ancestors.nil?
        c.prev_children_ancestor
      end
    end
  end
end

