module Import
  module PositionCsv
    def self.included(base)
      base.extend CsvBase
      base.extend ClassMethods
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

    def position_down_block
      Proc.new { |line, item|
        line<<item.detail
        line<<item.whouse_id
      }
    end

    def init_csv_cols
      csv_cols=[]
      csv_cols<< Csv::CsvCol.new(field: 'nr', header: 'PositionNr')
      csv_cols<< Csv::CsvCol.new(field: 'whouse_id', header: 'Ware House', is_foreign: true, foreign: 'Whouse')
      csv_cols<< Csv::CsvCol.new(field: $UPMARKER, header: $UPMARKER)
      class_variable_set(:@@csv_cols, csv_cols)
    end

    def csv_cols
      class_variable_get(:@@csv_cols)
    end

    def init_uniq_key
      class_variable_set(:@@ukeys, %w(detail whouse_id))
    end

    def import_csv(csv)
      headers = [{field: 'nr', header: 'Position Nr'},
                 {field: 'nr_new', header: 'Position New Nr', null: true},
                 {field: 'whouse_id', header: 'Warehouse Nr', is_foreign: true, foreign: 'Whouse'},
                 {field: $UPMARKER, header: $UPMARKER, null: true}]

      msg=Message.new
      #begin
      line_no=0
      CSV.foreach(csv.file_path, headers: true, col_sep: csv.col_sep, encoding: csv.encoding) do |row|
        row.strip
        line_no+=1

        data={}
        headers.each do |col|
          raise(ArgumentError, "行:#{line_no} #{col[:field]} 值不可为空") if row[col[:header]].blank? && col[:null].nil?
          data[col[:field]]=row[col[:header]]
        end

        operator=data.delete($UPMARKER)
        if warehouse=Warehouse.find_by_nr(data['whouse_id'])
          data['whouse_id']=warehouse.id
        end
        p = Position.find_by_nr(data['nr'])
        if operator=='update' || operator=='delete'
          if p
            if operator=='update'
              if data['nr_new']
                data['nr'] = data['nr_new']
              end
              data.delete('nr_new')
              p.update(data)
            else
              p.destroy
            end
          end
        else
          data.delete('nr_new')
          Position.create(data)
        end
      end
      msg.result=true
      msg.content='数据导入成功'
      return msg
    end
  end
end