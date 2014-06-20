module Import
  module PartPositionCsv
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
        line<<item.part_id
        line<<item.position_id
      }
    end

    def init_csv_cols
      @@csv_cols=[]
      @@csv_cols<< Csv::CsvCol.new(field: 'id', header: 'User Nr')
      @@csv_cols<< Csv::CsvCol.new(field: 'name', header: 'Name')
      @@csv_cols<< Csv::CsvCol.new(field: 'role_id', header: 'Role')
      @@csv_cols<< Csv::CsvCol.new(field: 'tel', header: 'Phone Nr')
      @@csv_cols<< Csv::CsvCol.new(field: 'location_id', header: 'Location')
      @@csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
    end

    def csv_cols
      @@csv_cols
    end
  end
end