class AddMatchValueToRegexCategory < ActiveRecord::Migration
  def change
    add_column :regex_categories, :match_value, :boolean,default: true
  end
end
