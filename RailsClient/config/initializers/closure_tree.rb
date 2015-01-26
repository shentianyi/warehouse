# ClosureTree::HierarchyMaintenance.module_eval do
#   def rebuild!(called_by_rebuild = false)
#     _ct.with_advisory_lock do
#       delete_hierarchy_references unless @was_new_record
#       hierarchy_class.create!(:ancestor => self, :descendant => self, :generations => 0)
#       unless root?
#         puts '******************'
#         _ct.connection.execute <<-SQL.strip_heredoc
#             INSERT INTO #{_ct.quoted_hierarchy_table_name}
#               (ancestor_id, descendant_id, generations,created_at,updated_at)
#             SELECT x.ancestor_id, #{_ct.quote(_ct_id)}, x.generations + 1,now(),now()
#             FROM #{_ct.quoted_hierarchy_table_name} x
#             WHERE x.descendant_id = #{_ct.quote(_ct_parent_id)}
#         SQL
#       end
#
#       if _ct.order_is_numeric? && !@_ct_skip_sort_order_maintenance
#         _ct_reorder_prior_siblings_if_parent_changed
#         # Prevent double-reordering of siblings:
#         _ct_reorder_siblings if !called_by_rebuild
#       end
#
#       children.each { |c| c.rebuild!(true) }
#
#       _ct_reorder_children if _ct.order_is_numeric? && children.present?
#     end
#   end
# end