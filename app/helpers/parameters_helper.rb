module ParametersHelper
  def self.update_by_client(client = nil, params)
    Parameter.all.each do |parameter|
      param_value = params["param_#{parameter.id}"]
      parameter = ParametersClient.create_or_find_by client_id: client, parameter_id: parameter.id
      parameter.update value: param_value
    end
  end
end
