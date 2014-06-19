class Presenter
  attr_accessor :delegators
  extend Forwardable

  #class<<self
  #  self.delegators
  #end

  def self.init_presenters params
    params.map{|param| self.new(param)}
  end

  def self.init_json_presenters params
    params.map{|param| self.new(param)}
  end

  def test
    self.delegators.to_json
  end
end