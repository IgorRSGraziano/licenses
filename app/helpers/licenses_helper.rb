module LicensesHelper
  def sort_arrow(url, param)
    uri = URI.parse(url)
    query = Rack::Utils.parse_query(uri.query)
    sort = query['sort']
    sort_order = sort.split(' ')[1]&.downcase
    sort_field = sort.split(' ')[0]&.downcase
    if (!sort_order.nil? || !sort_field.nil?) && sort_field == param.downcase
      if sort_order == 'asc'
        return 'arrow-down'
      else
        return 'arrow-up'
      end
    end
  end

end
