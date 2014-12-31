class ParamsService
  def self.parse_to_search(params)
    sort = parse_sort(params[:sort])
    params.delete(:route_info)
    params.delete(:sort) if params[:sort]
    args = params
    {args:args,sort:sort}
  end

  def self.parse_sort sort
    if sort
      sorts = sort.split(',')
      sorts.each do |s|

      end
    end
    nil
  end
end