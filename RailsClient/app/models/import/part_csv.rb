module Import
  module PartCsv
    def self.included(base)
      base.extend ClassMethods
      base.init_csv_rows
    end
  end

  module ClassMethods
    @@csv_rows=nil
    def uniq_key
      %w(id)
    end

    def csv_headers
      ['PartNr', 'UnitPack', $UPMARKER]
    end

    def down_block
      Proc.new { |line, item|
        line<<item.id
        line<<item.unit_pack
      }
    end
    def init_csv_rows
      @@csv_rows=[]
    end

    def csv_rows
      @@csv_rows
    end
  end
end