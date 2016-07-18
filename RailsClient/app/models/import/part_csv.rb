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
      class_variable_get(:@@ukeys)
    end

    def csv_headers
      class_variable_get(:@@csv_cols).collect { |col| col.header }
    end

    def part_down_block
      Proc.new { |line, item|
        line<<item.id
        line<<item.unit
        line<<item.unit_pack
        line<< item.part_type_id
        line<<item.convert_unit
        line<<item.description
        line<<item.customernum
        line<<item.supplier
        line<<item.mustCheck
        line<<item.checkpattem
        line<<item.isProducable
        line<< item.isFinalProduct
        line<<item.isWipProduct
        line<<item.isPurchasable
        line<<item.isSalable
      }
    end

    def init_csv_cols
      csv_cols=[]
      csv_cols<< Csv::CsvCol.new(field: 'id', header: 'PartNr')
      csv_cols<< Csv::CsvCol.new(field: 'unit', header: 'Unit',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'unit_pack', header: 'UnitPack',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'part_type_id', header: 'PartType', is_foreign: true, foreign: 'PartType',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'convert_unit', header: 'ConvertUnit',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'description', header: 'Description',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'customernum', header: 'CustomNum',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'supplier', header: 'Supplier',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'mustCheck', header: 'mustCheck',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'checkpattem', header: 'checkpattem',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'isProducable', header: 'isProducable',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'isFinalProduct', header: 'isFinalProduct',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'isWipProduct', header: 'isWipProduct',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'isPurchasable', header: 'isPurchasable',null:true)
      csv_cols<< Csv::CsvCol.new(field: 'isSalable', header: 'isSalable',null:true)
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