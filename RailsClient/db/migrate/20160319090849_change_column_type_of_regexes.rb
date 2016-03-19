class ChangeColumnTypeOfRegexes < ActiveRecord::Migration
  def change
    change_column :regexes,:suffix_string,:string
  end
end
