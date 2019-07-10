module V1::Entities::ServiceCategories

  class List < ::Grape::Entity
    expose :service_category do |obj,opts|
      obj.name.titleize
    end
    expose :position
    expose :services, with: 'V1::Entities::ServiceMetrics::Service' do |obj, opts|
      obj.services.only_visible.order('position ASC')
    end
  end

  class HeatmapList < ::Grape::Entity
    expose :service_category do |obj, opts|
      "Heatmap"
    end
    expose :services, with: 'V1::Entities::ServiceCategories::Heatmap' do |obj, opts|
      Heatmap.all()
    end
  end

  class Heatmap < ::Grape::Entity
    expose :id do |metric|
      metric._id.to_s
    end
    expose :name
    expose :display_name
    expose :type
    expose :metric_type do |metric|
      metric.metric_type || 'heatmap'
    end
    expose :description
    expose :features, if: {type: :detail} # TODO: Expose with an entity that doesn't show the coordinates
  end

end
