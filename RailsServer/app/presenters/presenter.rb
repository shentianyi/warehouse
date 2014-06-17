class Presenter
  extend Forwardable
  def self.init_presenters params
    params.map{|param| self.new(param)}
  end

  def self.init_json_presenters params
    params.map{|param| self.new(param)}
  end
end