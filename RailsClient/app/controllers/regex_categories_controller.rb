class RegexCategoriesController < ApplicationController
  before_action :set_regex_category, only: [:show, :edit, :update, :destroy]

  def index
    @regex_categories = RegexCategory.all
  end

  def show
    # respond_with(@regex_category)
  end

  def new
    @regex_category = RegexCategory.new
    @regex=Regex.new
  end

  def edit
    @regexes=@regex_category.regexes
  end

  def create
    @regex_category=RegexCategory.new(params[:regex_category])
    params[:regex].values.each do |regex|
      @regex_category.regexes<< Regex.new(regex)
    end
    respond_to do |format|
      if @regex_category.save
        format.html { redirect_to regex_categories_path, notice: 'RegexCategory was successfully created.' }
        format.json { render :show, status: :created, location: @regex_category }
      else
        format.html { render :new }
        format.json { render json: @regex_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    # render json: params
    params[:regex].values.each do |regex|
      if r= Regex.find_by_id(regex[:id])
        r.update_attributes(regex)
      end
    end

    respond_to do |format|
      if  @regex_category.update(regex_category_params)
        format.html { redirect_to regex_categories_path, notice: 'RegexCategory was successfully updated.' }
        format.json { render :show, status: :ok, location: @regex_category }
      else
        format.html { render :edit }
        format.json { render json: @regex_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @regex_category.destroy
    respond_to do |format|
      format.html { redirect_to regex_categories_path, notice: 'RegexCategory was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def regex_template
    case params[:type].to_i
      when RegexType::PACKAGE_LABEL
        render partial: 'pack_label_regex'
      when RegexType::ORDERITEM_LABEL
        render partial: 'order_label_regex'
    end
  end

  private
  def set_regex_category
    @regex_category = RegexCategory.find(params[:id])
  end

  def regex_category_params
    params.require(:regex_category).permit(:name, :desc, :type)
  end
end
