module V1
  class RegexAPI<Base
    namespace :regexes do
      guard_all!
      post :valid
      get :package_label do
        RegexPresenter.init_json_presenters(Regex.where(type: RegexType::PACKAGE_LABEL).all)
      end

      get :labels do
        RegexCategoryPresenter.init_json_presenters(RegexCategory.all)
        # data=[]
        # RegexType.types.each do |type|
        #   data<<{type: type,
        #          name: RegexType.display(type),
        #          regex_category: RegexCategoryPresenter.init_json_presenters(RegexCategory.where(type: type).all)}
        # end
        # data
      end
    end
  end
end