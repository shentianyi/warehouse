module Import
  module UserCsv
    def self.included(base)
      base.extend ClassMethods
      base.extend CsvBase
      base.init_csv_cols
      base.init_uniq_key
    end
  end

  module ClassMethods
    #@@csv_cols=nil

    def uniq_key
      class_variable_get(:@@ukeys)
    end

    def csv_headers
      class_variable_get(:@@csv_cols).collect { |col| col.header }
    end

    def user_down_block
      Proc.new { |line, item|
        line<<item.nr
        line<<item.name
        line<<item.role_id
        line<<item.tel
        line<<item.location_id
      }
    end

    def init_csv_cols
      csv_cols=[]
      csv_cols<< Csv::CsvCol.new(field: 'nr', header: 'User Nr')
      csv_cols<< Csv::CsvCol.new(field: 'name', header: 'Name')
      csv_cols<< Csv::CsvCol.new(field: 'role_id', header: 'Role')
      csv_cols<< Csv::CsvCol.new(field: 'tel', header: 'Phone Nr', null:true)
      csv_cols<< Csv::CsvCol.new(field: 'location_id', header: 'Location', is_foreign: true, foreign: 'Location', null:true)
      csv_cols<< Csv::CsvCol.new(field: 'password', header: 'Password',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'password_confirmation', header: 'Password Confirmation',null:true)
      csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
      class_variable_set(:@@csv_cols,csv_cols)
    end

    def csv_cols
      class_variable_get(:@@csv_cols)
    end

    def init_uniq_key
      class_variable_set(:@@ukeys,%w(nr))
    end
  end
end