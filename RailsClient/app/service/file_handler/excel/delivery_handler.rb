module FileHandler
  module Excel
    class DeliveryHandler<Base

      JIAXUAN_HEADERS=[
          :no, :forklift_id, :package_id, :no800, :cz_part_id, :sh_part_id, :qty, :unit, :batch
      ]

      JIAXUAN_ZH_HEADERS=[
          "序号", "托盘号", "HU号", "800号", "常州零件号", "上海零件号", "数量", "单位", "批次号"
      ]

      JXJX_HEADERS=[
          :part_id, :quantity, :package_id, :fifo, :part_package_id, :part_package_qty, :to_wh, :to_position, :remark
      ]

      JXJX_ZH_HEADERS=[
          "零件号", "数量", "唯一码", "FIFO", "料箱编号", "料箱数量", "接收仓库", "接收库位", "备注"
      ]

      JXJX_SEND_HEADERS=[
          :part_id, :quantity, :from_wh, :from_position, :package_id, :fifo, :part_package_id, :part_package_qty, :remark
      ]

      JXJX_SEND_ZH_HEADERS=[
          "零件号", "数量", "发货仓库", "发货库位", "唯一码", "FIFO", "料箱编号", "料箱数量", "备注"
      ]


      #######################################发货#####################################################
      def self.send_delivery file, user
        msg=Message.new

        validate_msg = validate_send(file)
        if validate_msg.result
          # begin
          ActiveRecord::Base.transaction do
            book=Roo::Excelx.new file.full_path

            # generate delivery
            # generate delivery container
            book.default_sheet=book.sheets.first
            return nil if book.cell(2, 1).nil?

            source = Location.find_by_nr(book.cell(2, 1))
            if source.blank?
              raise '没有正确配置发货地址'
            end

            destination = Location.find_by_nr(book.cell(2, 2))
            if destination.blank?
              raise '没有正确配置收货地址'
            end

            if book.cell(2, 5).blank?
              raise '装箱单号不能为空'
            end

            #calc wooden box nps count
            # wooden_count=0
            # box_count=0
            # nps_count=0

            fifo=book.cell(2, 3).to_time
            fifo=Time.now if fifo.blank?
            raise "fifo:#{fifo} 无效" if fifo > Time.now

            delivery = Delivery.create({
                                           fifo_time: fifo,
                                           remark: book.cell(2, 4),
                                           extra_batch: book.cell(2, 5),
                                           user_id: user.id,
                                           location_id: source.id,
                                           state: DeliveryState::RECEIVED
                                       })

            # generate delivery location_container
            # destination =source.default_location_destination #Location.find_by_nr(SysConfigCache.jiaxuan_extra_destination_value)

            dlc = delivery.logistics_containers.build(source_location_id: source.id, des_location_id: destination.id, user_id: user.id, remark: book.cell(2, 4), state: MovableState::CHECKED)
            dlc.destinationable = destination
            dlc.save
            # send dlc,create record for dlc
            impl_time = Time.now
            Record.create({recordable: dlc, impl_id: user.id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time})


            # generate forklifts containers
            forklift = Forklift.create({
                                           user_id: user.id,
                                           location_id: source.id,
                                           state: ForkliftState::RECEIVED
                                       })
            #create forklift lc
            flc = forklift.logistics_containers.build({source_location_id: source.id, des_location_id: destination.id, user_id: user.id, state: MovableState::CHECKED})
            flc.destinationable = destination
            flc.save
            Record.create({recordable: flc, impl_id: user.id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time})
            dlc.add(flc)


            # generate packages
            book.default_sheet=book.sheets[1]
            return nil if book.cell(2, 1).nil?

            move_list = MovementList.create(builder: user.id, name: "#{user.nr}_#{DateTime.now.strftime("%H.%d.%m.%Y")}_Send")
            2.upto(book.last_row) do |line|
              if book.cell(line, 2).blank?
                next
              end
              row = {}
              JXJX_SEND_HEADERS.each_with_index do |k, i|
                row[k] = book.cell(line, i+1).to_s.strip
                if ['package_id', 'part_id'].include?(k.to_s)
                  row[k]=row[k].sub(/\.0/, '')
                end
              end

              #create container
              part=Part.find_by_nr(row[:part_id])
              package = Package.create({
                                           location_id: source.id,
                                           fifo_time: fifo,
                                           part_id: part.id,
                                           user_id: user.id,
                                           quantity: row[:quantity],
                                           remark: row[:remark],
                                           state: PackageState::RECEIVED
                                       })
              #create lc
              plc = package.logistics_containers.build({
                                                           source_location_id: source.id,
                                                           des_location_id: destination.id,
                                                           user_id: user.id,
                                                           state: MovableState::CHECKED
                                                       })
              plc.destinationable = destination
              plc.save

              row[:fifo]=fifo if row[:fifo].blank?
              from_wh=Whouse.find_by_nr(row[:from_wh])
              from_position=Position.find_by_nr(row[:from_position])
              plc.move_stock(destination, from_wh, from_position, row[:fifo], move_list.id, false)

              Record.create({recordable: plc, impl_id: user.id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time})
              flc.add(plc)
            end
            move_list.update(state: MovementListState::ENDING)
          end

          msg.content ='处理成功'
          msg.result =true
          # rescue => e
          #   msg.result=false
          #   msg.content = e.message
          # end
        else
          msg.result = false
          msg.content = validate_msg.content
        end

        return msg
      end

      def self.validate_send file
        tmp_file=full_tmp_path(file.oriName)
        msg = Message.new(result: false)
        book = Roo::Excelx.new file.full_path

        book.default_sheet=book.sheets.first
        return nil if book.cell(2, 1).nil?

        source = Location.find_by_nr(book.cell(2, 1))
        if source.blank?
          msg.result=false
          msg.content= '没有正确配置发货地址'
          return msg
        end

        destination = Location.find_by_nr(book.cell(2, 2))
        if destination.blank?
          msg.result=false
          msg.content= '没有正确配置收货地址'
          return msg
        end

        if destination.whouses.first.blank?
          msg.result=false
          msg.content= '收货地址没有创建接收仓库'
          return msg
        end

        book.default_sheet=book.sheets[1]

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row JXJX_SEND_ZH_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            if book.cell(line, 2).blank?
              next
            end
            row = {}
            JXJX_SEND_HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              if ['package_id', 'part_id'].include?(k.to_s)
                row[k]=row[k].sub(/\.0/, '')
              end
            end

            mssg = validate_send_row(row, source)
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
        msg.result=true
        msg
      end

      def self.validate_send_row(row, location)
        msg = Message.new(contents: [])

        if row[:quantity].blank?
          msg.contents<<"数量:#{row[:quantity]}不能为空"
        else
          unless row[:quantity].to_f > 0
            msg.contents<<"数量:#{row[:quantity]}不合理"
          end
        end

        part = Part.find_by_nr(row[:part_id])
        unless part
          msg.contents << "零件号:#{row[:part_id]} 不存在!"
        end

        wh = Whouse.find_by_nr(row[:from_wh])
        if wh
          unless wh.location.id==location.id
            msg.contents << "发货仓库:#{row[:from_wh]}不属于发货地址:#{location.nr}"
          end
        else
          msg.contents << "仓库号:#{row[:from_wh]} 不存在!"
        end

        if row[:from_position].present?
          position = Position.find_by_nr(row[:from_position])
          unless position
            msg.contents << "库位号:#{row[:from_position]} 不存在!"
          else
            if wh
              unless position.whouse.id==wh.id
                msg.contents << "发货库位:#{row[:from_position]}不属于发货仓库:#{wh.nr}"
              end
            end
          end
        end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end

      #######################################收货#####################################################
      #####################################################################################################
      def self.receive_delivery file, user
        msg=Message.new

        validate_msg = validate_receive(file)
        if validate_msg.result
          # begin
          ActiveRecord::Base.transaction do
            book=Roo::Excelx.new file.full_path

            # generate delivery
            # generate delivery container
            book.default_sheet=book.sheets.first
            return nil if book.cell(2, 1).nil?

            source = Location.find_by_nr(book.cell(2, 1))
            if source.blank?
              raise '没有正确配置发货地址'
            end

            destination = Location.find_by_nr(book.cell(2, 2))
            if destination.blank?
              raise '没有正确配置收货地址'
            end

            if book.cell(2, 5).blank?
              raise '装箱单号不能为空'
            end

            #calc wooden box nps count
            # wooden_count=0
            # box_count=0
            # nps_count=0

            fifo=book.cell(2, 3).to_time
            raise "fifo:#{fifo} 无效" if fifo > Time.now

            delivery = Delivery.create({
                                           fifo_time: fifo,
                                           remark: book.cell(2, 4),
                                           extra_batch: book.cell(2, 5),
                                           user_id: user.id,
                                           location_id: source.id,
                                           state: DeliveryState::RECEIVED
                                       })

            # generate delivery location_container
            # destination =source.default_location_destination #Location.find_by_nr(SysConfigCache.jiaxuan_extra_destination_value)

            dlc = delivery.logistics_containers.build(source_location_id: source.id, des_location_id: destination.id, user_id: user.id, remark: book.cell(2, 4), state: MovableState::CHECKED)
            dlc.destinationable = destination
            dlc.save
            # send dlc,create record for dlc
            impl_time = Time.now
            Record.create({recordable: dlc, impl_id: user.id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time})


            # generate forklifts containers
            forklift = Forklift.create({
                                           user_id: user.id,
                                           location_id: source.id,
                                           state: ForkliftState::RECEIVED
                                       })
            #create forklift lc
            flc = forklift.logistics_containers.build({source_location_id: source.id, des_location_id: destination.id, user_id: user.id, state: MovableState::CHECKED})
            flc.destinationable = destination
            flc.save
            Record.create({recordable: flc, impl_id: user.id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time})
            dlc.add(flc)


            # generate packages
            book.default_sheet=book.sheets[1]
            return nil if book.cell(2, 1).nil?

            move_list = MovementList.create(builder: user.id, name: "#{user.nr}_#{DateTime.now.strftime("%H.%d.%m.%Y")}_Receive")
            2.upto(book.last_row) do |line|
              if book.cell(line, 2).blank?
                next
              end
              row = {}
              JXJX_HEADERS.each_with_index do |k, i|
                row[k] = book.cell(line, i+1).to_s.strip
                if ['package_id', 'part_id'].include?(k.to_s)
                  row[k]=row[k].sub(/\.0/, '')
                end
              end

              # if sh_pc.part.package_type_is_wooden?
              #   wooden_count+=1
              # elsif sh_pc.part.package_type_is_box?
              #   box_count+=1
              # else
              #   nps_count+=1
              # end

              #create container
              part=Part.find_by_nr(row[:part_id])
              package = Package.create({
                                           location_id: source.id,
                                           fifo_time: fifo,
                                           part_id: part.id,
                                           user_id: user.id,
                                           quantity: row[:quantity],
                                           remark: row[:remark],
                                           state: PackageState::RECEIVED
                                       })
              #create lc
              plc = package.logistics_containers.build({
                                                           source_location_id: source.id,
                                                           des_location_id: destination.id,
                                                           user_id: user.id,
                                                           state: MovableState::CHECKED
                                                       })
              plc.destinationable = destination
              plc.save

              to_wh=Whouse.find_by_nr(row[:to_wh])
              to_position=Position.find_by_nr(row[:to_position])
              plc.enter_stock(to_wh, to_position, row[:fifo], move_list.id, false)

              Record.create({recordable: plc, impl_id: user.id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time})
              flc.add(plc)
            end
            move_list.update(state: MovementListState::ENDING)
            # delivery.update_attributes(extra_wooden_count: wooden_count,
            #                            extra_box_count: box_count,
            #                            extra_nps_count: nps_count)
          end

          msg.content ='处理成功'
          msg.result =true
          # rescue => e
          #   msg.result=false
          #   msg.content = e.message
          # end
        else
          msg.result = false
          msg.content = validate_msg.content
        end

        return msg
      end

      def self.validate_receive file
        tmp_file=full_tmp_path(file.oriName)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path

        book.default_sheet=book.sheets.first
        return nil if book.cell(2, 1).nil?

        source = Location.find_by_nr(book.cell(2, 1))
        if source.blank?
          msg.result=false
          msg.content= '没有正确配置发货地址'
          return msg
        end

        destination = Location.find_by_nr(book.cell(2, 2))
        if destination.blank?
          msg.result=false
          msg.content= '没有正确配置收货地址'
          return msg
        end

        book.default_sheet=book.sheets[1]

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row JXJX_ZH_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            if book.cell(line, 2).blank?
              next
            end
            row = {}
            JXJX_HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              if ['package_id', 'part_id'].include?(k.to_s)
                row[k]=row[k].sub(/\.0/, '')
              end
            end

            mssg = validate_receive_row(row, destination)
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

      def self.validate_receive_row(row, location)
        msg = Message.new(contents: [])

        if row[:quantity].blank?
          msg.contents<<"数量:#{row[:quantity]}不能为空"
        else
          unless row[:quantity].to_f > 0
            msg.contents<<"数量:#{row[:quantity]}不合理"
          end
        end

        part = Part.find_by_nr(row[:part_id])
        unless part
          msg.contents << "零件号:#{row[:part_id]} 不存在!"
        end

        wh = Whouse.find_by_nr(row[:to_wh])
        if wh
          unless wh.location.id==location.id
            msg.contents << "入库仓库:#{row[:to_wh]}不属于收货地址:#{location.nr}"
          end
        else
          msg.contents << "仓库号:#{row[:to_wh]} 不存在!"
        end

        position = Position.find_by_nr(row[:to_position])
        unless position
          msg.contents << "库位号:#{row[:to_position]} 不存在!"
        end

        # if row[:sh_part_id].blank? || row[:cz_part_id].blank?
        #   msg.contents<<"上海客户零件或者常州客户零件不能为空"
        # else
        #   sh_custom=Tenant.find_by_code(SysConfigCache.jiaxuan_extra_sh_custom_value)
        #   cz_custom=Tenant.find_by_code(SysConfigCache.jiaxuan_extra_cz_custom_value)
        #
        #   unless sh_pc=PartClient.where(client_tenant_id: sh_custom.id, client_part_nr: row[:sh_part_id]).first
        #     msg.contents<<"没有找到对应的上海客户零件"
        #   end
        #
        #   unless cz_pc=PartClient.where(client_tenant_id: cz_custom.id, client_part_nr: row[:cz_part_id]).first
        #     msg.contents<<"没有找到对应的常州客户零件"
        #   end
        #
        #   if sh_pc && cz_pc && (sh_pc.part_id==cz_pc.part_id)
        #   else
        #     msg.contents<<"上海客户零件和常州客户零件的对于关系不正确"
        #   end
        #
        # end

        unless msg.result=(msg.contents.size==0)
          msg.content=msg.contents.join('/')
        end
        msg
      end

      ##########################################################################################################################################################
      def self.send_jiaxuan_delivery file, user
        msg=Message.new

        validate_msg = validate_import(file)
        if validate_msg.result
          # begin
          ActiveRecord::Base.transaction do
            book=Roo::Excelx.new file.full_path

            # generate delivery
            # generate delivery container
            source = Location.find_by_nr(SysConfigCache.jiaxuan_extra_source_value)

            if source.blank?
              raise '没有正确配置常州发运地址'
            end

            if (destination=source.default_destination).blank?
              raise '常州莱尼没有配置默认发运地点'
            end

            if (cz_send_warehouse=source.send_whouse).blank?
              raise '常州莱尼没有配置默认在途仓库'
            end

            #calc wooden box nps count
            wooden_count=0
            box_count=0
            nps_count=0

            delivery = Delivery.create({
                                           remark: '常州莱尼发运数据',
                                           user_id: user.id,
                                           location_id: source.id
                                       })

            # generate delivery location_container
            # destination =source.default_location_destination #Location.find_by_nr(SysConfigCache.jiaxuan_extra_destination_value)

            dlc = delivery.logistics_containers.build(source_location_id: source.id, des_location_id: destination.id, user_id: user.id, remark: '常州莱尼发运数据', state: MovableState::WAY)
            dlc.destinationable = destination
            dlc.save
            # send dlc,create record for dlc
            impl_time = Time.now
            Record.create({recordable: dlc, impl_id: user.id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time})


            # generate forklifts containers
            forklifts={}
            forklift_ids=[]

            book.default_sheet=book.sheets.first
            return nil if book.cell(2, 1).nil?
            2.upto(book.last_row) do |line|
              if book.cell(line, 2).blank?
                next
              end
              forklift_ids<<book.cell(line, 2).to_s.sub(/\.0/, '')
            end

            forklift_ids.uniq.each do |forklift_id|
              forklift = Forklift.create({
                                             id: forklift_id,
                                             user_id: user.id,
                                             location_id: source.id
                                         })
              #create forklift lc
              flc = forklift.logistics_containers.build({source_location_id: source.id, des_location_id: destination.id, user_id: user.id, state: MovableState::WAY})
              flc.destinationable = destination
              flc.save
              Record.create({recordable: flc, impl_id: user.id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time})
              dlc.add(flc)
              forklifts[forklift_id]=flc
            end

            # generate packages
            2.upto(book.last_row) do |line|
              if book.cell(line, 2).blank?
                next
              end
              row = {}
              JIAXUAN_HEADERS.each_with_index do |k, i|
                row[k] = book.cell(line, i+1).to_s.strip
                if ['forklift_id', 'package_id', 'no800', 'cz_part_id', 'sh_part_id', 'batch'].include?(k.to_s)
                  row[k]=row[k].sub(/\.0/, '')
                end
              end

              if plc = LogisticsContainer.find_latest_by_container_id(row[:package_id])
                #if found and can copy
                forklifts[row[:forklift_id]].add(plc)
              else

                sh_custom=Tenant.find_by_code(SysConfigCache.jiaxuan_extra_sh_custom_value)
                sh_pc=PartClient.where(client_tenant_id: sh_custom.id, client_part_nr: row[:sh_part_id]).first

                if sh_pc.part.package_type_is_wooden?
                  wooden_count+=1
                elsif sh_pc.part.package_type_is_box?
                  box_count+=1
                else
                  nps_count+=1
                end

                #create container
                package = Package.create({
                                             id: row[:package_id],
                                             location_id: source.id,
                                             part_id: sh_pc.part_id,
                                             user_id: user.id,
                                             quantity: row[:qty],
                                             state: PackageState::WAY,
                                             extra_800_no: row[:no800],
                                             extra_cz_part_id: row[:cz_part_id],
                                             extra_sh_part_id: row[:sh_part_id],
                                             extra_unit: row[:unit],
                                             extra_batch: row[:batch]
                                         })
                #create lc
                plc = package.logistics_containers.build({
                                                             source_location_id: source.id,
                                                             des_location_id: destination.id,
                                                             user_id: user.id,
                                                             state: MovableState::WAY
                                                         })
                plc.destinationable = destination
                plc.save

                plc.enter_stock(cz_send_warehouse, cz_send_warehouse.default_position, Time.now)

                Record.create({recordable: plc, impl_id: user.id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time})
                forklifts[row[:forklift_id]].add(plc)
              end
            end

            delivery.update_attributes(extra_wooden_count: wooden_count,
                                       extra_box_count: box_count,
                                       extra_nps_count: nps_count)
          end

          msg.content ='处理成功'
          msg.result =true
          # rescue => e
          #   msg.result=false
          #   msg.content = e.message
          # end
        else
          msg.result = false
          msg.content = validate_msg.content
        end

        return msg
      end

      def self.validate_import file
        tmp_file=full_tmp_path(file.oriName)
        msg = Message.new(result: true)
        book = Roo::Excelx.new file.full_path
        book.default_sheet = book.sheets.first

        p = Axlsx::Package.new
        p.workbook.add_worksheet(:name => "Basic Worksheet") do |sheet|
          sheet.add_row JIAXUAN_ZH_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            if book.cell(line, 2).blank?
              next
            end
            row = {}
            JIAXUAN_HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              if ['forklift_id', 'package_id', 'no800', 'cz_part_id', 'sh_part_id', 'batch'].include?(k.to_s)
                row[k]=row[k].sub(/\.0/, '')
              end
            end

            mssg = validate_row(row)
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

      def self.validate_row(row)
        msg = Message.new(contents: [])

        if row[:forklift_id].blank?
          msg.contents<<"托盘号:#{row[:forklift_id]}不能为空"
        else
          unless Forklift.find_by_id(row[:forklift_id]).blank?
            msg.contents<<"托盘号:#{row[:forklift_id]}已存在"
          end
        end

        if row[:package_id].blank?
          msg.contents<<"HU号:#{row[:package_id]}不能为空"
        else
          unless Package.find_by_id(row[:package_id]).blank?
            msg.contents<<"HU号:#{row[:package_id]}已存在"
          end
        end

        if row[:qty].blank?
          msg.contents<<"数量:#{row[:qty]}不能为空"
        else
          unless row[:qty].to_f > 0
            msg.contents<<"数量:#{row[:qty]}不合理"
          end
        end

        if row[:sh_part_id].blank? || row[:cz_part_id].blank?
          msg.contents<<"上海客户零件或者常州客户零件不能为空"
        else
          sh_custom=Tenant.find_by_code(SysConfigCache.jiaxuan_extra_sh_custom_value)
          cz_custom=Tenant.find_by_code(SysConfigCache.jiaxuan_extra_cz_custom_value)

          unless sh_pc=PartClient.where(client_tenant_id: sh_custom.id, client_part_nr: row[:sh_part_id]).first
            msg.contents<<"没有找到对应的上海客户零件"
          end

          unless cz_pc=PartClient.where(client_tenant_id: cz_custom.id, client_part_nr: row[:cz_part_id]).first
            msg.contents<<"没有找到对应的常州客户零件"
          end

          if sh_pc && cz_pc && (sh_pc.part_id==cz_pc.part_id)
          else
            msg.contents<<"上海客户零件和常州客户零件的对于关系不正确"
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