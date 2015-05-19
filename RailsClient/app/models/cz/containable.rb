module CZ
  module Containable
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
        return false
      end
      true
    end
  end
end