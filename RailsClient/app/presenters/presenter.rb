class Presenter
  attr_accessor :delegators
  extend Forwardable

=begin
  class<<self
    self.delegators.each do |m|
      define_method(m) {

      }
    end
  end
=end

  def self.init_presenters params
    params.map{|param| self.new(param)}
  end

  def self.init_json_presenters params
    params.map{|param| self.new(param)}
  end
=begin

  def to_json
    json={}
    self.delegators.each do |dele|
      json[dele]=self.send(dele)
    end
    return json
  end
=end
end