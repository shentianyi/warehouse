module FileHandler
  module Excel
    class DeliveryHandler<Base

      HEADERS=[
          :package_id, :part_id, :qty
      ]

      ZH_HEADERS=[
          "唯一码", "零件号", "数量"
      ]

      def self.send_jiaxuan_delivery file, user
        msg=Message.new

        validate_msg = validate_import(file)
        if validate_msg.result
          # begin
            ActiveRecord::Base.transaction do
              book=Roo::Excelx.new file.full_path

              # generate delivery
              # generate delivery container
              # source = Location.find_by_nr(SysConfigCache.jiaxuan_extra_source_value)
              #
              # if source.blank?
              #   raise '没有正确配置常州发运地址'
              # end

              unless (destination=user.location)
                raise '默认发运地点不存在'
              end

              unless user.location.receive_whouse
                raise '接收仓库不存在'
              end

              delivery = Delivery.create({
                                             remark: '上海稳信接收数据',
                                             user_id: user.id
                                         })

              # generate delivery location_container
              # destination =source.default_location_destination #Location.find_by_nr(SysConfigCache.jiaxuan_extra_destination_value)

              dlc = delivery.logistics_containers.build(des_location_id: destination.id, user_id: user.id, remark: '上海稳信接收数据', state: MovableState::WAY)
              dlc.destinationable = destination
              dlc.save
              # send dlc,create record for dlc
              impl_time = Time.now
              Record.create({recordable: dlc, impl_id: user.id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time})


              # generate forklifts containers
              # forklifts={}
              # forklift_ids=[]

              book.default_sheet=book.sheets.first
              return nil if book.cell(2, 1).nil?

              forklift = Forklift.create({
                                             remark: '上海稳信接收数据',
                                             user_id: user.id
                                         })
              #create forklift lc
              flc = forklift.logistics_containers.build({des_location_id: destination.id, user_id: user.id, state: MovableState::WAY})
              flc.destinationable = destination
              flc.save
              Record.create({recordable: flc, impl_id: user.id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time})
              dlc.add(flc)
              # forklifts[forklift_id]=flc

              # 2.upto(book.last_row) do |line|
              #   if book.cell(line, 2).blank?
              #     next
              #   end
              #   forklift_ids<<book.cell(line, 2).to_s.sub(/\.0/, '')
              # end
              #
              # forklift_ids.uniq.each do |forklift_id|
              #   forklift = Forklift.create({
              #                                  id: forklift_id,
              #                                  user_id: user.id,
              #                                  location_id: source.id
              #                              })
              #   #create forklift lc
              #   flc = forklift.logistics_containers.build({source_location_id: source.id, des_location_id: destination.id, user_id: user.id, state: MovableState::WAY})
              #   flc.destinationable = destination
              #   flc.save
              #   Record.create({recordable: flc, impl_id: user.id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time})
              #   dlc.add(flc)
              #   forklifts[forklift_id]=flc
              # end

              # generate packages
              2.upto(book.last_row) do |line|
                if book.cell(line, 2).blank?
                  next
                end
                row = {}
                HEADERS.each_with_index do |k, i|
                  row[k] = book.cell(line, i+1).to_s.strip
                  if ['package_id', 'part_id'].include?(k.to_s)
                    row[k]=row[k].sub(/\.0/, '')
                  end
                end

                if plc = LogisticsContainer.find_latest_by_container_id(row[:package_id])
                  #if found and can copy
                  flc.add(plc)
                else

                  part=Part.find_by_nr(row[:part_id])

                  #create container
                  package = Package.create({
                                               id: row[:package_id],
                                               # location_id: source.id,
                                               part_id: part.id,
                                               user_id: user.id,
                                               quantity: row[:qty],
                                               state: PackageState::WAY,
                                               # extra_800_no: row[:no800],
                                               # extra_cz_part_id: row[:cz_part_id],
                                               # extra_sh_part_id: row[:sh_part_id],
                                               # extra_unit: row[:unit],
                                               # extra_batch: row[:batch]
                                           })
                  #create lc
                  plc = package.logistics_containers.build({
                                                               # source_location_id: source.id,
                                                               des_location_id: destination.id,
                                                               user_id: user.id,
                                                               state: MovableState::WAY
                                                           })
                  plc.destinationable = destination
                  plc.save

                  plc.enter_stock(user.location.receive_whouse, user.location.receive_whouse.default_position, Time.now)

                  Record.create({recordable: plc, impl_id: user.id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time})
                  # forklifts[row[:forklift_id]].add(plc)
                  flc.add(plc)
                end
              end

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
          sheet.add_row ZH_HEADERS+['Error Msg']
          #validate file
          2.upto(book.last_row) do |line|
            if book.cell(line, 2).blank?
              next
            end
            row = {}
            HEADERS.each_with_index do |k, i|
              row[k] = book.cell(line, i+1).to_s.strip
              if ['package_id', 'part_id'].include?(k.to_s)
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

        if row[:package_id].blank?
          msg.contents<<"唯一码:#{row[:package_id]}不能为空"
        else
          unless Package.find_by_id(row[:package_id]).blank?
            msg.contents<<"唯一码:#{row[:package_id]}已存在"
          end
        end

        if row[:qty].blank?
          msg.contents<<"数量:#{row[:qty]}不能为空"
        else
          unless row[:qty].to_f > 0
            msg.contents<<"数量:#{row[:qty]}不合理"
          end
        end

        if row[:part_id].blank?
          msg.contents<<"零件不能为空"
        else
          part=Part.find_by_nr(row[:part_id])
          unless part
            msg.contents<<"零件不存在"
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