class ParamsService
  def self.parse_to_search(params)
    sort = parse_sort(params[:sort])
    params.delete(:route_info)
    params.delete(:sort) if params[:sort]
    limit = params[:limit].nil? ? nil : params[:limit]
    params.delete(:limit)
    args = params
    {args:args,sort:sort,limit:limit}
  end

  def self.parse_sort sort
    if sort
      sorts = []
      sort.split(',').each do |s|
        if !s.start_with?("-","+")
          s = "+#{s}"
        end

        operator = s[0]
        op = 'ASC'
        case operator
          when '+'
            op = 'ASC'
          when '-'
            op = 'DESC'
        end
        s = s[1..-1]
        sorts << "#{s} #{op}"
      end
      return sorts.join(',')
    end
    nil
  end
end