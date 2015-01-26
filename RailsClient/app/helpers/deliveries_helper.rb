require 'action_view'

module DeliveriesHelper
  def self.transfer_old_deliveries ids

    ds = Old::ODelivery.where(id:ids)
    begin
      ds.each_with_index do |od, index|
        ActiveRecord::Base.transaction do
          #create Delivery Container
          #puts "#{idx}-#{index}"
          d = Delivery.create({
                                  id: od.id,
                                  remark: od.remark,
                                  user_id: od.user_id,
                                  location_id: od.user.location_id,
                                  created_at: od.created_at,
                                  updated_at: od.updated_at,
                                  is_delete: od.is_delete,
                                  is_new: od.is_new,
                                  is_dirty: od.is_dirty
                              })


          dlc = d.logistics_containers.build(source_location_id: od.user.location_id, user_id: od.user_id, remark: od.remark)
          dlc.destinationable = od.destination
          dlc.des_location_id = od.destination_id

          destination = od.destination

          default_sender = User.where({role_id: Role.sender}).first
          default_receiver = User.where({role_id: Role.receiver}).first
          user_id = nil
          #change state
          #注意每一个record的时间，应该和od的时间一致，或者尽量保持一致
          case od.state
            when DeliveryState::ORIGINAL
              dlc.state = MovableState::INIT
            when DeliveryState::WAY
              dlc.state = MovableState::WAY
              #*record dispatch
              impl_time = od.delivery_date.nil? ? od.created_at : od.delivery_date
              Record.create({recordable: dlc, destinationable: dlc.destinationable, impl_id: od.user_id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time, is_new: od.is_new, is_delete: od.is_delete, is_dirty: od.is_dirty})
            when DeliveryState::DESTINATION
              dlc.state = MovableState::ARRIVED
              #*record dispatch
              impl_time = od.delivery_date.nil? ? od.created_at : od.delivery_date
              Record.create({recordable: dlc, destinationable: dlc.destinationable, impl_id: od.user_id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time, is_new: od.is_new, is_delete: od.is_delete, is_dirty: od.is_dirty})
              #*record receive
              impl_time = od.received_date.nil? ? od.updated_at : od.received_date
              user_id = od.receiver_id.nil? ? default_receiver : od.receiver_id
              Record.create({recordable: dlc, destinationable: dlc.destinationable, impl_id: user_id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time, is_new: od.is_new, is_delete: od.is_delete, is_dirty: od.is_dirty})
            when DeliveryState::RECEIVED
              dlc.state = MovableState::CHECKED
              #*record dispatch
              impl_time = od.delivery_date.nil? ? od.created_at : od.delivery_date
              Record.create({recordable: dlc, destinationable: dlc.destinationable, impl_id: od.user_id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time, is_new: od.is_new, is_delete: od.is_delete, is_dirty: od.is_dirty})
              #*record receive
              impl_time = od.received_date.nil? ? od.updated_at : od.received_date
              user_id = od.receiver_id.nil? ? default_receiver : od.receiver_id
              Record.create({recordable: dlc, destinationable: dlc.destinationable, impl_id: user_id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time, is_new: od.is_new, is_delete: od.is_delete, is_dirty: od.is_dirty})
              #*record check
              impl_time = od.received_date.nil? ? od.updated_at : od.received_date
              user_id = od.receiver_id.nil? ? default_receiver : od.receiver_id
              Record.create({recordable: dlc, destinationable: dlc.destinationable, impl_id: user_id, impl_user_type: ImplUserType::EXAMINER, impl_action: 'check', impl_time: impl_time, is_new: od.is_new, is_delete: od.is_delete, is_dirty: od.is_dirty})
            when DeliveryState::REJECTED
              dlc.state = MovableState::REJECTED
              #*record dispatch
              impl_time = od.delivery_date.nil? ? od.created_at : od.delivery_date
              Record.create({recordable: dlc, destinationable: dlc.destinationable, impl_id: od.user_id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time, is_new: od.is_new, is_delete: od.is_delete, is_dirty: od.is_dirty})
              #*record receive
              impl_time = od.received_date.nil? ? od.updated_at : od.received_date
              user_id = od.receiver_id.nil? ? default_receiver : od.receiver_id
              Record.create({recordable: dlc, destinationable: dlc.destinationable, impl_id: user_id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time, is_new: od.is_new, is_delete: od.is_delete, is_dirty: od.is_dirty})
              #*record rejected
              impl_time = od.received_date.nil? ? od.updated_at : od.received_date
              user_id = od.receiver_id.nil? ? default_receiver : od.receiver_id
              Record.create({recordable: dlc, destinationable: dlc.destinationable, impl_id: user_id, impl_user_type: ImplUserType::REJECTOR, impl_action: 'reject', impl_time: impl_time, is_new: od.is_new, is_delete: od.is_delete, is_dirty: od.is_dirty})
          end
          #get all forklift and added to delivery
          dlc.created_at = od.created_at
          dlc.updated_at = od.updated_at
          dlc.is_new = od.is_new
          dlc.is_delete = od.is_delete
          dlc.is_dirty = od.is_dirty
          dlc.save
          #puts "#{d.id} => DC \n"
          #puts "#{dlc.id} => DLC \n"
          #puts "#{dlc.records.count} => DLC Records created! \n"
          od.forklifts.each do |of|
            #注意，这里只统计到了运单中的Forklift，但是没有统计到不存在晕但中的forklift
            f = Forklift.create({
                                    id: of.id,
                                    user_id: of.user_id,
                                    location_id: of.user.location_id,
                                    created_at: of.created_at,
                                    updated_at: of.updated_at,
                                    remark: of.remark,
                                    is_delete: of.is_delete,
                                    is_new: of.is_new,
                                    is_dirty: of.is_dirty
                                })
            flc = f.logistics_containers.build(source_location_id: of.user.location_id, user_id: of.user_id, destinationable: of.whouse)
            flc.des_location_id = destination.id if destination

            #set state
            #create records
            case of.state
              when ForkliftState::ORIGINAL
                flc.state = MovableState::INIT
              when ForkliftState::WAY
                flc.state = MovableState::WAY
                #record dispatch
                impl_time = of.created_at
                Record.create({recordable: flc, destinationable: flc.destinationable, impl_id: of.user_id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time, is_new: of.is_new, is_delete: of.is_delete, is_dirty: of.is_dirty})
              when ForkliftState::DESTINATION
                flc.state = MovableState::ARRIVED
                #record dispatch
                impl_time = of.created_at
                Record.create({recordable: flc, destinationable: flc.destinationable, impl_id: of.user_id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time, is_new: of.is_new, is_delete: of.is_delete, is_dirty: of.is_dirty})
                #record receive
                impl_time = of.updated_at
                Record.create({recordable: flc, destinationable: flc.destinationable, impl_id: user_id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time, is_new: of.is_new, is_delete: of.is_delete, is_dirty: of.is_dirty})
              when ForkliftState::RECEIVED, ForkliftState::PART_RECEIVED
                flc.state = MovableState::CHECKED
                #record dispatch
                impl_time = of.created_at
                Record.create({recordable: flc, destinationable: flc.destinationable, impl_id: of.user_id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time, is_new: of.is_new, is_delete: of.is_delete, is_dirty: of.is_dirty})
                #record receive
                impl_time = of.updated_at
                Record.create({recordable: flc, destinationable: flc.destinationable, impl_id: user_id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time, is_new: of.is_new, is_delete: of.is_delete, is_dirty: of.is_dirty})
                #record check
                Record.create({recordable: flc, destinationable: flc.destinationable, impl_id: user_id, impl_user_type: ImplUserType::EXAMINER, impl_action: 'check', impl_time: impl_time, is_new: of.is_new, is_delete: of.is_delete, is_dirty: of.is_dirty})
            end

            dlc.add(flc)
            flc.created_at = of.created_at
            flc.updated_at = of.updated_at
            flc.is_new = of.is_new
            flc.is_delete = of.is_delete
            flc.is_dirty = of.is_dirty
            flc.save

            #puts "#{f.id} => FC \n"
            #puts "#{flc.id} => Fflc \n"
            #puts "#{flc.records.count} => Fflc Records \n"

            #packages
            of.packages.each do |op|
              fifo_time = nil
              begin
                fifo_time = Time.parse(op.check_in_time)
              rescue
                fifo_time = Time.now
              end
              p = Package.create({
                                     id: op.id,
                                     quantity: op.quantity,
                                     quantity_display: "Q#{op.quantity}",
                                     user_id: op.user_id,
                                     location_id: op.location_id,
                                     fifo_time: fifo_time,
                                     fifo_time_display: "W  #{op.check_in_time}",
                                     part_id: op.part_id,
                                     part_id_display: "P#{op.part_id}",
                                     created_at: op.created_at,
                                     updated_at: op.updated_at,
                                     is_delete: op.is_delete,
                                     is_new: op.is_new,
                                     is_dirty: op.is_dirty
                                 })
              #
              plc = p.logistics_containers.build({source_location_id: op.location_id, user_id: op.user_id})
              plc.destinationable = flc.destinationable #PartService.get_position_by_whouse_id(op.part_id,flc.destinationable_id)
              plc.des_location_id = destination.id if destination

              case op.state
                when PackageState::ORIGINAL
                  plc.state = MovableState::INIT
                when PackageState::WAY
                  plc.state = MovableState::WAY

                  #record dispatch
                  impl_time = op.created_at
                  Record.create({recordable: plc, destinationable: plc.destinationable, impl_id: op.user_id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time, is_new: op.is_new, is_delete: op.is_delete, is_dirty: op.is_dirty})
                when PackageState::DESTINATION
                  if of.state != PackageState::ORIGINAL && of.state != PackageState::WAY
                    plc.state = MovableState::REJECTED
                    #record dispatch
                    impl_time = op.created_at
                    Record.create({recordable: plc, destinationable: plc.destinationable, impl_id: op.user_id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time, is_new: op.is_new, is_delete: op.is_delete, is_dirty: op.is_dirty})
                    #record receive
                    impl_time = op.updated_at
                    Record.create({recordable: plc, destinationable: plc.destinationable, impl_id: user_id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time, is_new: op.is_new, is_delete: op.is_delete, is_dirty: op.is_dirty})
                    #record rejected
                    impl_time = op.updated_at
                    Record.create({recordable: plc, destinationable: plc.destinationable, impl_id: user_id, impl_user_type: ImplUserType::REJECTOR, impl_action: 'reject', impl_time: impl_time, is_new: op.is_new, is_delete: op.is_delete, is_dirty: op.is_dirty})
                  else
                    plc.state = MovableState::ARRIVED

                    #record dispatch
                    impl_time = op.created_at
                    Record.create({recordable: plc, destinationable: plc.destinationable, impl_id: op.user_id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time, is_new: op.is_new, is_delete: op.is_delete, is_dirty: op.is_dirty})
                    #record receive
                    impl_time = op.updated_at
                    Record.create({recordable: plc, destinationable: plc.destinationable, impl_id: user_id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time, is_new: op.is_new, is_delete: op.is_delete, is_dirty: op.is_dirty})
                  end
                when PackageState::RECEIVED
                  plc.state = MovableState::CHECKED
                  #record dispatch
                  impl_time = op.created_at
                  Record.create({recordable: plc, destinationable: plc.destinationable, impl_id: op.user_id, impl_user_type: ImplUserType::SENDER, impl_action: 'dispatch', impl_time: impl_time, is_new: op.is_new, is_delete: op.is_delete, is_dirty: op.is_dirty})
                  #record receive
                  impl_time = op.updated_at
                  Record.create({recordable: plc, destinationable: plc.destinationable, impl_id: user_id, impl_user_type: ImplUserType::RECEIVER, impl_action: 'receive', impl_time: impl_time, is_new: op.is_new, is_delete: op.is_delete, is_dirty: op.is_dirty})
                  #record rejected
                  impl_time = op.updated_at
                  Record.create({recordable: plc, destinationable: plc.destinationable, impl_id: user_id, impl_user_type: ImplUserType::EXAMINER, impl_action: 'check', impl_time: impl_time, is_new: op.is_new, is_delete: op.is_delete, is_dirty: op.is_dirty})
                when PackageState::REJECTED
                  plc.state = MovableState::REJECTED

              end
              flc.add(plc)
              plc.created_at = op.created_at
              plc.updated_at = op.updated_at
              plc.is_new = op.is_new
              plc.is_delete = op.is_delete
              plc.is_dirty = op.is_dirty
              plc.save

              #puts "#{p.id} => PC \n"
              #puts "#{plc.id} => PLC \n"
              #$puts "#{plc.records.count} => PLC Records \n"

            end
          end
          #puts "---------------------------------------------"
        end
      end
    rescue Exception => e
      puts "Error:#{e}"
      e.backtrace.each { |line| puts line }
    end

    ActiveRecord::Base.connection.close()
  end
end
