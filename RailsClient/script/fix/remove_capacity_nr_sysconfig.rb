SysConfig.transaction do
  if sysconfig=SysConfig.find_by_code('CAPACITY_NR')
    sysconfig.destroy
  end
end
