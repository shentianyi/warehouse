module Import
  module PartPositionCsv
    def self.included(base)
      base.extend ClassMethods
      base.extend CsvBase
      base.init_csv_cols
    end
  end

  module ClassMethods
    #@@csv_cols=nil

    def uniq_key
      #%w(id)
    end

    def csv_headers
      class_variable_get(:@@csv_cols).collect { |col| col.header }
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
      csv_cols=[]
      csv_cols<< Csv::CsvCol.new(field: 'part_id', header: 'Part Nr')
      csv_cols<< Csv::CsvCol.new(field: 'position_id', header: 'Position Nr', is_foreign: true, foreign:'Position')
      csv_cols<< Csv::CsvCol.new(field: 'position', header: 'Position')
      csv_cols<< Csv::CsvCol.new(field: 'whouse', header: 'Ware House')


      csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
      class_variable_set(:@@csv_cols,csv_cols)
    end

    def csv_cols
      class_variable_get(:@@csv_cols)
    end
  end
end