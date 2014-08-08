class ApiActionEnum
  #forklift action
  FActions=[:f_list,:f_create, :f_add_p,:f_remove_p, :f_delete,:f_update]
  #package action
  PActions=[:p_create,:p_delete,:p_update,:p_check,:p_uncheck]
  #delivery action
  DActions=[:d_create,:d_add_forklift,:d_remove_forklift,:d_send,:d_receive,:d_confirm_receive]
end