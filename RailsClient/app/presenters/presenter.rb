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

  def test
    a = []
    self.delegators.each do |d|
      a << self[d.to_s.to_sym]
    end
    a
  end

  def init
    self.delegators.each do |m|
      define_method(m) {

      }
    end
  end
end