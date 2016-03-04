module FileHandler
  module Excel
    class DeliveryHandler<Base

      JIAXUAN_HEADERS=[
          :no, :forklift_id, :package_id, :no800, :cz_part_id, :sh_part_id, :qty, :unit, :batch
      ]

      JIAXUAN_ZH_HEADERS=[
          "序号", "运单号", "HU号", "800号", "常州零件号", "上海零件号", "数量", "单位", "批次号"
      ]


      def self.send_jiaxuan_delivery file, user
        msg=Message.new

        validate_msg = validate_import(file)
        if validate_msg.result
          begin
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

                  plc.enter_stock(cz_send_warehouse,cz_send_warehouse.default_position,Time.now)

                  Record.create({recordable: plc, impl_id: user.id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time})
                  forklifts[row[:forklift_id]].add(plc)
                end
              end

            end

            msg.content ='处理成功'
            msg.result =true
          rescue => e
            msg.result=false
            msg.content = e.message
          end
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