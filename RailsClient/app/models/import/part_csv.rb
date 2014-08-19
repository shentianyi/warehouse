module Import
  module PartCsv
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
      class_variable_get(:@@keys)
    end

    def csv_headers
      class_variable_get(:@@csv_cols).collect { |col| col.header }
    end

    def part_down_block
      Proc.new { |line, item|
        line<<item.id
        line<<item.unit_pack
        line<< item.part_type_id
      }
    end

    def init_csv_cols
      csv_cols=[]
      csv_cols<< Csv::CsvCol.new(field: 'id', header: 'PartNr')
      csv_cols<< Csv::CsvCol.new(field: 'unit_pack', header: 'UnitPack')
      csv_cols<< Csv::CsvCol.new(field: 'part_type_id', header: 'PartType', is_foreign: true, foreign: 'PartType')
      csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
      class_variable_set(:@@csv_cols, csv_cols)
    end

    def csv_cols
      class_variable_get(:@@csv_cols)
    end

    def init_uniq_key
      class_variable_set(:@@ukeys,%w(id))
    end
  end
end