module Import
  module LedCsv
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

    def led_down_block
      Proc.new { |line, item|
        line<<item.signal_id
        line<<item.modem_id
        line<< item.position
      }
    end

    def init_csv_cols
      csv_cols=[]
      csv_cols<< Csv::CsvCol.new(field: 'signal_id', header: 'PAN_ID')
      csv_cols<< Csv::CsvCol.new(field: 'modem_id', header: 'ModemId', is_foreign:true, foreign:'Modem')
      csv_cols<< Csv::CsvCol.new(field: 'mac', header: 'Mac')
      csv_cols<< Csv::CsvCol.new(field: 'position', header: 'Position')
      csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
      class_variable_set(:@@csv_cols, csv_cols)
    end

    def csv_cols
      class_variable_get(:@@csv_cols)
    end

    def init_uniq_key
      class_variable_set(:@@ukeys,%w(signal_id modem_id))
    end

  end
end