module Import
  module PartPositionCsv
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

    def part_position_down_block
      Proc.new { |line, item|
        line<<item.part.nr
        line<<item.position.nr
        line<<item.sourceable.nr
        line<<item.position.nr if item.position
        line<<item.position.whouse.name if item.position
      }
    end

    def init_csv_cols
      csv_cols=[]
      csv_cols<< Csv::CsvCol.new(field: 'part_id', header: 'PartNr', is_foreign: true, foreign:'Part')
      csv_cols<< Csv::CsvCol.new(field: 'position_id', header: 'Position', is_foreign: true, foreign:'Position')
      csv_cols<< Csv::CsvCol.new(field: 'sourceable_id', header: 'LocationNr',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'position', header: 'Position')
      csv_cols<< Csv::CsvCol.new(field: 'whouse', header: 'Warehouse')
      csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
      class_variable_set(:@@csv_cols,csv_cols)
    end

    def csv_cols
      class_variable_get(:@@csv_cols)
    end


    def init_uniq_key
      class_variable_set(:@@ukeys,%w(part_id position_id))
    end
  end
end