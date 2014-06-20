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
      #%w(id)
    end

    def csv_headers
      @@csv_cols.collect { |col| col.header }
    end

    def down_block
      Proc.new { |line, item|
        line<<item.part_id
        line<<item.position_id
        line<<item.position.detail
        line<<item.position.whouse.name
      }
    end

    def init_csv_cols
      @@csv_cols=[]
      @@csv_cols<< Csv::CsvCol.new(field: 'part_id', header: 'Position Nr')
      @@csv_cols<< Csv::CsvCol.new(field: 'position_id', header: 'Position Nr')
      @@csv_cols<< Csv::CsvCol.new(field: 'position', header: 'Position')
      @@csv_cols<< Csv::CsvCol.new(field: 'whouse', header: 'Ware House')


      @@csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
    end

    def csv_cols
      @@csv_cols
    end
  end
end