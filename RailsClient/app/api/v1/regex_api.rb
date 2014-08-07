module V1
  class RegexAPI<Base
    namespace :regexes
    guard_all!
    post :valid
    get :package_label do
      RegexPresenter.init_json_presenters(Regex.where(type: RegexType::PACKAGE_LABEL).all)
    end

    get :labels do
      RegexPresenter.init_json_presenters(Regex.all)
    end
  end
end