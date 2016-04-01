NStorage.transaction do
  NStorage.where(locked: false)
      .update_all(locked: true,
                  lock_user_id: 'admin',
                  lock_remark: '20151207盘点覆盖锁定',
                  lock_at: Time.now.utc)
  # raise
end