module Import
  module LocationCsv
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

    def location_down_block
      Proc.new { |line, item|
        line<<item.id
        line<<item.name
        line<<item.address
        line<<item.tel
        line<<item.destination_id
        line<<item.receive_whouse_id
        line<<item.send_whouse_id
        line<<item.order_source_location_id
        line<<item.tenant_id
      }
    end

    def init_csv_cols
      csv_cols=[]
      csv_cols<< Csv::CsvCol.new(field: 'id', header: 'LocationNr')
      csv_cols<< Csv::CsvCol.new(field: 'name', header: 'Name')
      csv_cols<< Csv::CsvCol.new(field: 'address', header: 'Address')
      csv_cols<< Csv::CsvCol.new(field: 'tel', header: 'Telephone', null:true)
      csv_cols<< Csv::CsvCol.new(field: 'destination_id', header: 'Destination', is_foreign:true, foreign:'Location')

      csv_cols<< Csv::CsvCol.new(field: 'receive_whouse_id', header: '接收仓库', is_foreign:true, foreign:'Whouse')
      csv_cols<< Csv::CsvCol.new(field: 'send_whouse_id', header: '在途仓库', is_foreign:true, foreign:'Whouse')
      csv_cols<< Csv::CsvCol.new(field: 'order_source_location_id', header: '要货地点', is_foreign:true, foreign:'Location')
      csv_cols<< Csv::CsvCol.new(field: 'tenant_id', header: '所属公司', is_foreign:true, foreign:'Tenant')

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