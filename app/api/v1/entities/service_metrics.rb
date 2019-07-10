module V1::Entities::ServiceMetrics

  class List < ::Grape::Entity
    expose :service_category do |obj,opts|
      obj[0].name.titleize
    end
    expose :services, with: 'V1::Entities::ServiceMetrics::Service' do |obj, opts|
      obj[1]
    end
  end

  class Service < ::Grape::Entity
    expose :service_type do |obj,opts|
      obj.service_type&.titleize
    end
    expose :position
    expose :service_metrics, with: 'V1::Entities::ServiceMetrics::MetricList' do |obj, opts|
      obj.service_metrics.only_visible.order(position: :asc)
    end
  end

  class MetricList < ::Grape::Entity
    expose :name
    expose :display_name
    expose :description
    expose :data_source
    expose :data_verification
    expose :vintage
    expose :position
    expose :id do |metric|
      metric._id.to_s
    end
    expose :metric_type do |metric|
      metric.metric_type || 'service'
    end
    expose :geometry_type do |metric|
      # Try is added because the live traffic is from google API which does not
      # have service_assets
      metric.service_assets.first&.geometry&.type
    end
  end

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
