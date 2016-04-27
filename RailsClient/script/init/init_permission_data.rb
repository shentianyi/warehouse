#############################菜单管理##################################

unless Permission.find_by_name("view_pick")
  Permission.create(name: "view_pick", description: "查看择货菜单")
end

unless Permission.find_by_name("view_order")
  Permission.create(name: "view_order", description: "查看要货菜单")
end

unless Permission.find_by_name("view_delivery")
  Permission.create(name: "view_delivery", description: "查看发运菜单")
end

unless Permission.find_by_name("view_movement_list")
  Permission.create(name: "view_movement_list", description: "查看移库单菜单")
end

unless Permission.find_by_name("view_storage")
  Permission.create(name: "view_storage", description: "查看库存菜单")
end

unless Permission.find_by_name("view_inventory_list")
  Permission.create(name: "view_inventory_list", description: "查看盘点菜单")
end

unless Permission.find_by_name("view_scrap")
  Permission.create(name: "view_scrap", description: "查看报废菜单")
end

unless Permission.find_by_name("view_back_part")
  Permission.create(name: "view_back_part", description: "查看退货菜单")
end

unless Permission.find_by_name("view_report")
  Permission.create(name: "view_report", description: "查看报表菜单")
end

unless Permission.find_by_name("view_basic_info")
  Permission.create(name: "view_basic_info", description: "查看基础信息菜单")
end

unless Permission.find_by_name("view_emergency")
  Permission.create(name: "view_emergency", description: "查看应急方案菜单")
end

unless Permission.find_by_name("view_extra")
  Permission.create(name: "view_extra", description: "查看扩展权限菜单")
end

unless Permission.find_by_name("view_configuration")
  Permission.create(name: "view_configuration", description: "查看配置菜单")
end

unless Permission.find_by_name("view_system_log")
  Permission.create(name: "view_system_log", description: "查看系统日志菜单")
end

###########################权限管理################################

unless Permission.find_by_name("manage_permission")
  Permission.create(name: "manage_permission", description: "权限管理中心")
end

############################操作权限#########################

unless Permission.find_by_name("operate_order_create")
  Permission.create(name: "operate_order_create", description: "要货新建权限")
end

unless Permission.find_by_name("operate_order_edit")
  Permission.create(name: "operate_order_edit", description: "要货编辑权限")
end

unless Permission.find_by_name("operate_order_delete")
  Permission.create(name: "operate_order_delete", description: "要货删除权限")
end

unless Permission.find_by_name("operate_delivery")
  Permission.create(name: "operate_delivery", description: "发运编辑权限")
end

unless Permission.find_by_name("operate_storage")
  Permission.create(name: "operate_storage", description: "库存导入导出权限")
end

unless Permission.find_by_name("operate_inventory_create")
  Permission.create(name: "operate_inventory_create", description: "盘点新建权限")
end

unless Permission.find_by_name("operate_report_upload")
  Permission.create(name: "operate_report_upload", description: "报表上传权限")
end

unless Permission.find_by_name("operate_scrap_create")
  Permission.create(name: "operate_scrap_create", description: "报废新建权限")
end

unless Permission.find_by_name("operate_scrap_edit")
  Permission.create(name: "operate_scrap_edit", description: "报废编辑权限")
end

unless Permission.find_by_name("operate_scrap_delete")
  Permission.create(name: "operate_scrap_delete", description: "报废删除权限")
end

unless Permission.find_by_name("operate_back_part_create")
  Permission.create(name: "operate_back_part_create", description: "退货新建权限")
end

unless Permission.find_by_name("operate_back_part_edit")
  Permission.create(name: "operate_back_part_edit", description: "退货编辑权限")
end

unless Permission.find_by_name("operate_back_part_delete")
  Permission.create(name: "operate_back_part_delete", description: "退货删除权限")
end

unless Permission.find_by_name("operate_basic_info_create")
  Permission.create(name: "operate_basic_info_create", description: "基础信息新建权限")
end

unless Permission.find_by_name("operate_basic_info_edit")
  Permission.create(name: "operate_basic_info_edit", description: "基础信息编辑权限")
end

unless Permission.find_by_name("operate_basic_info_delete")
  Permission.create(name: "operate_basic_info_delete", description: "基础信息删除权限")
end

#########################################扩展权限########################################

unless Permission.find_by_name("jiaxuan_extra_config")
  Permission.create(name: "jiaxuan_extra_config", description: "佳轩扩展配置修改权限")
end

unless Permission.find_by_name("jiaxuan_extra_export")
  Permission.create(name: "jiaxuan_extra_export", description: "佳轩扩展导入发运数据")
end