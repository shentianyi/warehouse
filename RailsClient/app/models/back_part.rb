class BackPart < ActiveRecord::Base
  include Extensions::UUID

  has_many :back_part_items, :dependent => :destroy
  belongs_to :des_location, class_name: 'Location'
  belongs_to :src_location, class_name: 'Location'
  belongs_to :user

  # before_save :convert_time
  #
  # def convert_time
  #   p self
  #   self.back_time=self.back_time.utc
  # end

  def generate_id
    "BP#{Time.now.to_milli}"
  end

  def self.to_xlsx back_parts
    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(:name => "sheet1") do |sheet|
      sheet.add_row ["序号", "退货单号", "创建者", "退货单接收地", "退货单创建地", "退货日期",
                     "零件号", "数量", "仓库号", "库位号", "退货原因", "样品", "备注"]
      back_parts.each { |back_part|
        back_part.back_part_items.each_with_index do |item, index|
          sheet.add_row [
                            index+1,
                            back_part.id,
                            back_part.user.blank? ? "" : back_part.user.nr,
                            back_part.des_location.blank? ? '' : back_part.des_location.nr,
                            back_part.src_location.blank? ? '' : back_part.src_location.nr,
                            back_part.back_time.blank? ? '' : back_part.back_time.localtime.strftime('%y.%m.%d %H:%M'),
                            item.part.blank? ? '' : item.part.nr,
                            item.qty,
                            item.whouse.blank? ? '' : item.whouse.nr,
                            item.position.blank? ? '' : item.position.nr,
                            item.back_reason,
                            item.has_sample ? 'Y' : 'N',
                            item.remark
                        ], types: [:string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string, :string]

        end
      }
    end
    p.to_stream.read
  end
end
