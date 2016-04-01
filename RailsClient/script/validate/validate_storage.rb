# Version.all.where("object LIKE '%partNr: P00108645%' AND object LIKE '%ware_house_id: SR01%'").each do |version|
#   version.
# end


p = Axlsx::Package.new
ss=1
NStorage.where(partNr: 'p00115867', ware_house_id: 'SR01').each do |storage|

  wb = p.workbook
  wb.add_worksheet(:name => "sheet#{ss}") do |sheet|
    sheet.add_row ["序号", "零件号", "仓库号", "库位号", "数量", "FIFO", "创建时间", "唯一码"]
    storage.versions.each_with_index { |version, index|
      if version.reify
        sheet.add_row [
                          index+1,
                          version.reify.partNr,
                          version.reify.ware_house_id,
                          version.reify.position,
                          version.reify.qty,
                          version.reify.fifo.present? ? version.reify.fifo.localtime.strftime("%Y-%m-%d %H:%M") : '',
                          version.reify.created_at.present? ? version.reify.created_at.localtime.strftime("%Y-%m-%d %H:%M") : '',
                          version.reify.packageId
                      ]
      end
    }
  end

  ss+=1
end



p.serialize('storage.xlsx')
