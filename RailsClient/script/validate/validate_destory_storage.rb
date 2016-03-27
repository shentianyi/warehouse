Version.all.where("object LIKE '%partNr: P00108645%' AND object LIKE '%ware_house_id: SR01%'").each do |version|
  version.object
end