class HotmartTransaction
  include ActiveModel::Serializers::JSON

  attr_accessor :id, :creation_date, :event, :version

  def initialize(params)
    params.each do |key, value|
      instance_variable_set("@#{key}", value) unless value.nil?
    end
  end
end