module Import
  module PartCsv
    def self.included(base)
      base.extend ClassMethods

    end
  end

  module ClassMethods
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
  end
end