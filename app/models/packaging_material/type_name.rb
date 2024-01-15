module PackagingMaterial::TypeName
  extend ActiveSupport::Concern

  included do
    attribute :type_name, :string, default: model_name.element.classify
  end
end
