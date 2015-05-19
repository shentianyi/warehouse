class AddRegexCategoryToRegexes < ActiveRecord::Migration
  def change
    add_column :regexes, :regex_category_id, :string
    add_index :regexes, :regex_category_id
    change_column_null :regexes, :type, true
  end
end
