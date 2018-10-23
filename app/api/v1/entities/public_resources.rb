module V1::Entities::PublicResources

  class Base < ::Grape::Entity
    expose :type do |obj, opts|
      "FeatureCollection"
    end
    expose :resource_details, as: :features, with: 'V1::Entities::PublicResources::ResourceDetail' do |obj, opts|
      obj.resource_details.where(resource_type: opts[:resource_type])
    end
  end

  class ResourceDetail < ::Grape::Entity
    expose :type do |obj, opts|
      "Feature"
    end
    expose :properties
    expose :geometry do |obj, opts|
      obj.geometry
    end
  end

  class Geometry < ::Grape::Entity
    expose :type
    expose :coordinates
  end

end
