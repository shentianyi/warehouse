module Import
  module PickItemFilterCsv
    def self.included(base)
      base.extend ClassMethods
      base.extend CsvBase
      base.init_csv_cols
      base.init_uniq_key
    end
  end

  module ClassMethods
    def uniq_key
      class_variable_get(:@@ukeys)
    end

    def csv_headers
      class_variable_get(:@@csv_cols).collect { |col| col.header }
    end

    def pack_item_filter_down_block
      Proc.new { |line, item|
        line<<item.user_id
        line<<item.filterable_type
        line<<item.filterable_id
      }
    end

    def init_csv_cols
      csv_cols=[]
      csv_cols<< Csv::CsvCol.new(field: 'user_id', header: 'UserID')
      csv_cols<< Csv::CsvCol.new(field: 'filterable_type', header: 'Type')
      csv_cols<< Csv::CsvCol.new(field: 'filterable_id', header: 'Value')
      csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
      class_variable_set(:@@csv_cols, csv_cols)
    end

    def csv_cols
      class_variable_get(:@@csv_cols)
    end

    def init_uniq_key
      class_variable_set(:ukeys,%w(user_id filterable_type filterable_id))
    end
  end
end