require 'csv'

module ReportsHelper
  def self.csv_filter file
    res_hash = {}
    jsfile = JSON.parse(file)
    f = FileData.new(jsfile)
    fors_data = []
    CSV.foreach(f.full_path, headers: true,col_sep: ';') do |row|
      _params = {}
      fors_sys_keys.each do |key|
        if row[key].is_number?
          _params[key] = row[key].to_i.to_s
        else
          _params[key] = row[key]
        end
      end
      fors_data << _params
    end

    fors_data.each {|fd|
      if res_hash[fd["PartNr."]+fd["Warehouse"]].nil?
        res_hash[fd["PartNr."]+fd["Warehouse"]] = {"PartNr." => fd["PartNr."],"Warehouse"=>fd["Warehouse"],"Amount"=>0}
      end
      res_hash[fd["PartNr."]+fd["Warehouse"]]["Amount"] = res_hash[fd["PartNr."]+fd["Warehouse"]]["Amount"] + fd["Quantity"].to_f
    }
    return res_hash.sort_by {|key,value| value["Warehouse"]}

    return res_hash
  end

  def self.xlsx_filter file
    res_hash = {}
    jsfile = JSON.parse(file)
    f = FileData.new(jsfile)
    book = Roo::Excelx.new f.full_path

    book.default_sheet = book.sheets.first
    headers = []
    book.row(1).each {|header|
      headers << header
    }

    fors_data = []

    2.upto(book.last_row) do |line|
      params = {}
      headers.each_with_index{|key,i|
        params[key] = book.cell(line,i+1).to_s
      }

      insert = true
      _params = {}
      fors_sys_keys.each {|key|
        if insert && (params[key].nil? || params[key].to_s.blank?)
          insert = false
          break
        end

        if params[key].is_number?
          _params[key] = params[key].to_i.to_s
        else
          _params[key] = params[key]
        end
      }
      fors_data << _params
    end

    fors_data.each {|fd|
      if res_hash[fd["PartNr."]+fd["Warehouse"]].nil?
        res_hash[fd["PartNr."]+fd["Warehouse"]] = {"PartNr." => fd["PartNr."],"Warehouse"=>fd["Warehouse"],"Amount"=>0}
      end
      res_hash[fd["PartNr."]+fd["Warehouse"]]["Amount"] = res_hash[fd["PartNr."]+fd["Warehouse"]]["Amount"] + fd["Quantity"].to_f
    }
    return res_hash.sort_by {|key,value| value["Warehouse"]}
  end

  private
  def self.fors_sys_keys
    ["PartNr.","Warehouse","Quantity"]
  end
end
