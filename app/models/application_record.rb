class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def self.h(attr = nil)
    return pl(1) if attr.nil?
    return I18n.t "activerecord.#{attr}" if %i[updated_at created_at].include?(attr)

    human_attribute_name attr
  end

  def self.pl(count = 2)
    model_name.human count:
  end
end
