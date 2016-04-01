p = Axlsx::Package.new
wb = p.workbook

# wb.add_worksheet(:name => "sheet1") do |sheet|
#   ##<Version id: 1385479, item_type: "NStorage", item_id: 116164, event: "update", whodunnit: "admin", object: "---\nid: 116164\nstorageId: \npartNr: '420002844'\nfif...", created_at: "2015-11-20 02:17:55">
#
#   sheet.add_row ["id", "item_type", "item_id", "event", "whodunnit", "warehouse", "position", "qty", "created_at"]
#   Version.where("object like ?", "%partNr: '420002844'%").each_with_index do |v, i|
#
#     a=v.object.split("\n")[1..-1].map { |a| a.split(': ') }.map { |a| a.size==1 ? a<<'' : a }
#     h=Hash[a.each.to_a]
#     h['qty']=h['qty'].sub(/!ruby\/object:BigDecimal 27:/, '')
#     n=NStorage.new(h)
#     p "#{i}-------------#{v.to_json}--#{n.qty}"
#     sheet.add_row [
#                       v.id,
#                       v.item_type,
#                       v.item_id,
#                       v.event,
#                       v.whodunnit,
#                       n.ware_house_id,
#                       n.position,
#                       n.qty,
#                       v.created_at.localtime.to_s
#                   ]
#
#   end
# end


wb.add_worksheet(:name => "sheet1") do |sheet|
  sheet.add_row ["id", "item_type", "item_id", "event", "whodunnit", "warehouse", "position", "qty", "created_at"]

  NStorage.where(partNr: '420002844').each do |n|
    sheet.add_row [
                      '',
                      '',
                      n.id,
                      '',
                      '',
                      n.ware_house_id,
                      n.position,
                      n.qty,
                      ''
                  ]

    n.versions.reverse.each_with_index do |v, i|
      if v.object.blank?
      else
        a=v.object.split("\n")[1..-1].map { |a| a.split(': ') }.map { |a| a.size==1 ? a<<'' : a }
        h=Hash[a.each.to_a]
        h['qty']=h['qty'].sub(/!ruby\/object:BigDecimal 27:/, '')
        n=NStorage.new(h)
        p "#{i}-------------#{v.to_json}--#{n.qty}"
        sheet.add_row [
                          v.id,
                          v.item_type,
                          v.item_id,
                          v.event,
                          v.whodunnit,
                          n.ware_house_id,
                          n.position,
                          n.qty,
                          v.created_at.localtime.to_s
                      ]
      end
    end
  end
end

p.to_stream.read

p.serialize('/home/lzd/桌面/2.xlsx')




