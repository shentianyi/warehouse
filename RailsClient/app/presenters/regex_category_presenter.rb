class RegexCategoryPresenter<Presenter
  Delegators=[:id, :name, :desc, :type, :regexes]
  def_delegators :@regex, *Delegators

  def initialize regex
    @regex = regex
    self.delegators = Delegators
  end

  def name
    @regex.name || ''
  end

  def desc
    @regex.desc || ''
  end

  def self.init_json_presenters params, with_regex=true
    params.map { |param| self.new(param).to_json(with_regex) }
  end

  def to_json(with_regex=false)
    {
        id: self.id,
        name: self.name,
        desc: self.desc,
        regexes: with_regex ? RegexPresenter.init_json_presenters(self.regexes) : []
    }
  end
end