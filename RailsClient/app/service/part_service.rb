class PartService
  def self.validate_id id,current_user
=begin
    if id.start_with?(current_user.location.prefix)
      id = id.slice(current_user.location.prefix.length,id.length-current_user.location.prefix)
    end

    if id.end_with?(current_user.location.suffix)
      id = id.slice(0,id.length-current_user.location.prefix)
    end
=end

    !Part.find_by_id(id).nil?
  end

  def self.import_part_position csv
    headers = [{field:'part_id',header: 'PartNr'} ,
               {field:'position',header: 'Position'},
               {field:'sourceable_id',header:'LocationId',null:true},
               {field:$UPMARKER,header: $UPMARKER,null:true}]
#puts headers
    msg=Message.new
    #begin
      line_no=0
      CSV.foreach(csv.file_path, headers: true, col_sep: csv.col_sep, encoding: csv.encoding) do |row|
        row.strip
        line_no+=1
        if self.respond_to?(:csv_headers)
          raise(ArgumentError, "#{headers.join(' /')} 为必须包含列!") unless headers.empty?
        end

        data={}
        headers.each do |col|
          raise(ArgumentError, "行:#{line_no} #{col[:field]} 值不可为空") if row[col[:header]].blank? && col[:null].nil?
          data[col[:field]]=row[col[:header]]
          data['sourceable_type']='Location'
          #puts data
        end
        if p =  Position.find_by_detail(data['position'])
          data.delete('position')
          data['position_id'] = p.id
        else
          raise(ArgumentError, "行:#{line_no} Position 不存在对应的库位")
        end

        # clean data
        update_marker=(data.delete($UPMARKER).to_i==1)

        if pp = PartPosition.where({part_id:data['part_id'],position_id:p.id}).first && !update_marker
          raise(ArgumentError, "行:#{line_no} 该零件已存在相同库位")
        end

        #1 means delete
        if update_marker
          #if delete
          query={part_id:data['part_id'],position_id:  data['position_id'] }
          if item=PartPosition.where(query).first
            item.destroy
          end
        else
          #if create
          PartPosition.create(data)
        end

        msg.result=true
        msg.content='数据导入成功'
      end
    #rescue => e
    #  puts e.backtrace
    #  msg.content =e.message
    #end
    return msg
  end
end