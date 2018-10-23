module V1::Entities::ServiceMetrics

  class Base < ::Grape::Entity
    expose :type do |obj, opts|
      "FeatureCollection"
    end
    expose :service_assets, as: :features, with: 'V1::Entities::ServiceMetrics::ServiceAsset' do |obj, opts|
      obj.service_assets.filtered_coordinates
    end
  end

  class ServiceAsset < ::Grape::Entity
    expose :type do |obj, opts|
      "Feature"
    end
    expose :basic_details do |obj, opts|
      obj.get_basic_properties
    end
    expose :properties
    expose :geometry do |obj, opts|
      obj.geometry
    end
  end

  class Numpoints < ::Grape::Entity
    expose :numpoint_count
    expose :numpoint_type
    expose :level
  end


end
