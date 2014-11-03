require_relative "cz_base.rb"

class ActionRecord < CZBase
  attr_accessor :id,:action_id,:action_type,:source_id,:destination_id,:container_id,:state

  def initialize(args={})
    self.id = "AR#{Random.new(10000)}"
    args.each do |k, v|
      self.instance_variable_set("@#{k}", v) unless v.nil?
    end
  end
end