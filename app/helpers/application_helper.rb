module ApplicationHelper
  def add_param_to_url(url, params)
    uri = URI.parse(url)

    query = Rack::Utils.parse_query(uri.query)

    query[params[:key]] = params[:value]

    uri.query = Rack::Utils.build_query(query)
    uri.to_s
  end
end
