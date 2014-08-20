class PartService
  def self.validate_id id, current_user
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
    headers = [{field: 'part_id', header: 'PartNr'},
               {field: 'position', header: 'Position'},
               {field: 'position_new', header: 'Position New', null: true},
               {field: 'sourceable_id', header: 'LocationId', null: true},
               {field: $UPMARKER, header: $UPMARKER, null: true}]
#puts headers
    msg=Message.new
#begin
    line_no=0
    skip = 0
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
      end

      if p = Position.find_by_detail(data['position'])
        data.delete('position')
        data['position_id'] = p.id
      else
        raise(ArgumentError, "行:#{line_no} Position 不存在对应的库位")
      end

      # clean data
      update_marker=(data.delete($UPMARKER).to_i==1)

      if update_marker
        if data['position_new'] && p_new = Position.find_by_detail(data['position_new'])
          data.delete('position_new')
          data['position_id'] = p_new.id
        else
          raise(ArgumentError, "行:#{line_no} Position New 不存在对应的库位")
        end
      end
      data.delete('position_new')

      if (pp = PartPosition.where({part_id: data['part_id'], position_id: p.id}).first) && !update_marker
        skip = skip + 1
        next
      end

      #1 means delete
      if update_marker
        if pp
          pp.update(data)
        else
          raise(ArgumentError, "行:#{line_no} 零件库位不存在，无法修改")
        end
      else
        PartPosition.create(data)
      end
    end
    msg.result=true
    msg.content="数据导入成功,#{skip}条数据重复"

    return msg
  end
end