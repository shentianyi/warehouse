module FileHandler
  module Excel
    class WrappageMovementHandler<Base
      IMPORT_HEADERS=[
          :move_date, :package_type_id, :enter_from_cz_qty, :extra_800_nos, :enter_from_sh_qty, :send_to_sh_qty, :extra_leoni_out_no, :back_from_sh_qty, :back_to_cz_qty, :user_id
      ]

      def self.import(file, user)
        msg = Message.new
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        validate_msg = validate_import(file)
        if validate_msg.result
          begin
            WrappageMovement.transaction do
              jx=user.location
              cz=jx.order_source_location
              sh=jx.destinations.first
              2.upto(book.last_row) do |line|
                row = {}
                IMPORT_HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                end

                if package_type = PackageType.find_by_nr(row[:package_type_id])
                  row[:package_type_id]=package_type.id
                end
                if u = User.find_by_nr(row[:user_id])
                  row[:user_id]=u.id
                else
                  row[:user_id]=user.id
                end

                unless wm=WrappageMovement.where(move_date: row[:move_date], package_type_id: row[:package_type_id]).first
                  wm=WrappageMovement.new({
                                              move_date: row[:move_date],
                                              package_type_id: row[:package_type_id]
                                          })
                  wm.user=user
                end

                unless row[:enter_from_cz_qty].blank?
                  enter_from_cz = WrappageMovementItem.new({
                                                         qty: row[:enter_from_cz_qty],
                                                         wrappage_move_type_id: WrappageMoveType::ENTER_FROM_CZ,
                                                         extra_800_nos: row[:extra_800_nos]
                                                     })
                  enter_from_cz.src_location=cz
                  enter_from_cz.des_location=jx
                  enter_from_cz.user=user
                  wm.wrappage_movement_items<<enter_from_cz
                end

                unless row[:enter_from_sh_qty].blank?
                  enter_from_sh = WrappageMovementItem.new({
                                                         qty: row[:enter_from_sh_qty],
                                                         wrappage_move_type_id: WrappageMoveType::ENTER_FROM_SH
                                                     })
                  enter_from_sh.src_location=sh
                  enter_from_sh.des_location=jx
                  enter_from_sh.user=user
                  wm.wrappage_movement_items<<enter_from_sh
                end

                unless row[:send_to_sh_qty].blank?
                  send_to_sh = WrappageMovementItem.new({
                                                         qty: row[:send_to_sh_qty],
                                                         wrappage_move_type_id: WrappageMoveType::SEND_TO_SH
                                                     })
                  send_to_sh.src_location=jx
                  send_to_sh.des_location=sh
                  send_to_sh.user=user
                  wm.wrappage_movement_items<<send_to_sh
                end

                unless row[:back_from_sh_qty].blank?
                  back_from_sh = WrappageMovementItem.new({
                                                            qty: row[:back_from_sh_qty],
                                                            wrappage_move_type_id: WrappageMoveType::BACK_FROM_SH,
                                                            extra_leoni_out_no: row[:extra_leoni_out_no]
                                                        })
                  back_from_sh.src_location=sh
                  back_from_sh.des_location=jx
                  back_from_sh.user=user
                  wm.wrappage_movement_items<<back_from_sh
                end

                unless row[:back_to_cz_qty].blank?
                  back_to_cz = WrappageMovementItem.new({
                                                              qty: row[:back_to_cz_qty],
                                                              wrappage_move_type_id: WrappageMoveType::BACK_TO_CZ
                                                          })
                  back_to_cz.src_location=jx
                  back_to_cz.des_location=cz
                  back_to_cz.user=user
                  wm.wrappage_movement_items<<back_to_cz
                end

                wm.save
              end
            end
            msg.result = true
            msg.content = "导入数据成功"
          rescue => e
            puts e.backtrace
            msg.result = false
            msg.content = e.message
          end
        else
          msg.result = false
          msg.content = validate_msg.content
        end

        msg
      end

      def self.validate_import file
        tmp_file=full_tmp_path(file.oriName)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row IMPORT_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            row = {}
            IMPORT_HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              # row[k]=row[k].sub(/\.0/, '') if k== :user_id
            end

            mssg = validate_import_row(row, line)
            if mssg.result
              sheet.add_row row.values
            else
              if msg.result
                msg.result = false
                msg.content = "下载错误文件<a href='/files/#{Base64.urlsafe_encode64(tmp_file)}'>#{::File.basename(tmp_file)}</a>"
              end
              sheet.add_row row.values<<mssg.content
            end
          end
        end
        p.use_shared_strings = true
        p.serialize(tmp_file)
        msg
      end

      def self.validate_import_row(row, line)
        msg = Message.new(contents: [])
        if row[:move_date].present?
          unless row[:move_date].is_date?
            msg.contents << "日期:#{row[:move_date]} 不合法!"
          end
        else
          msg.contents << "日期:#{row[:move_date]} 不能为空!"
        end

        if row[:package_type_id].present?
          package_type = PackageType.find_by_nr(row[:package_type_id])
          unless package_type
            msg.contents << "包装物类型:#{row[:package_type_id]} 不存在!"
          end
        else
          msg.contents << "包装物类型:#{row[:package_type_id]} 不能为空!"
        end

        if row[:user_id].present?
          user = User.find_by_nr(row[:user_id])
          unless user
            msg.contents << "员工号:#{row[:user_id]} 不存在!"
          end
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end


    end
  end
end
