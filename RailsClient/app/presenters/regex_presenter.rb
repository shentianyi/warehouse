class RegexPresenter<Presenter
  Delegators=[:id,:name,:code,:prefix_string,:suffix_string,:prefix_length,:suffix_length,:regex_string]
  def_delegators :@regex,*Delegators

  def initialize regex
    @regex = regex
    self.delegators = Delegators
  end

  def prefix_string
    @regex.prefix_string || ''
  end

  def suffix_string
    @regex.suffix_string || ''
  end
end