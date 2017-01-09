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

    p '-----------------------'
    puts(params)
    p '-----------------------'

    params.map { |param| self.new(param) }
  end

  def self.init_json_presenters params
    params.map { |param| self.new(param).to_json }
  end

  def to_json
    json={}
    self.delegators.each do |dele|
      json[dele]=self.send(dele)
    end
    return json
  end
end