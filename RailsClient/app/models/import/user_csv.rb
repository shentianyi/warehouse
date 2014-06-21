module Import
  module UserCsv
    def self.included(base)
      base.extend ClassMethods
      base.extend CsvBase
      base.init_csv_cols
    end
  end

  module ClassMethods
    @@csv_cols=nil

    def uniq_key
      %w(id)
    end

    def csv_headers
      @@csv_cols.collect { |col| col.header }
    end

    def down_block
      Proc.new { |line, item|
        line<<item.id
        line<<item.name
        line<<item.role_id
        line<<item.tel
        line<<item.location_id
      }
    end

    def init_csv_cols
      @@csv_cols=[]
      @@csv_cols<< Csv::CsvCol.new(field: 'id', header: 'User Nr')
      @@csv_cols<< Csv::CsvCol.new(field: 'name', header: 'Name')
      @@csv_cols<< Csv::CsvCol.new(field: 'role_id', header: 'Role')
      @@csv_cols<< Csv::CsvCol.new(field: 'tel', header: 'Phone Nr', null:true)
      @@csv_cols<< Csv::CsvCol.new(field: 'location_id', header: 'Location', is_foreign: true, foreign: Location, null:true)
      @@csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
    end

    def csv_cols
      @@csv_cols
    end
  end
end