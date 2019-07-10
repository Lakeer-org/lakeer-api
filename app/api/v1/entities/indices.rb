module V1::Entities::Indices

  class Base < ::Grape::Entity
    expose :id do |index| index._id.to_s end
    expose :name
    expose :description
    expose :child_groups, with: 'V1::Entities::Indices::Group', unless: {collection: true} do |index|
      index.child_groups.where(parent_group: nil).order_by(:position.asc)
    end
    expose :child_metrics, with: 'V1::Entities::Indices::IndexMetric', unless: {collection: true} do |index|
      index.child_metrics.where(parent_group: nil).order_by(:position.asc)
    end
    expose :owner_id do |index| index.owner_id.to_s end
    expose :boundaries
  end

  class Group < ::Grape::Entity
    expose :id do |group| group._id.to_s end
    expose :name
    expose :is_checked
    expose :child_groups, with: 'V1::Entities::Indices::Group' do |group|
      group.child_groups.order_by(:position.asc)
    end
    expose :child_metrics, with: 'V1::Entities::Indices::IndexMetric' do |group|
      group.child_metrics.order_by(:position.asc)
    end
  end

  class IndexMetric < ::Grape::Entity
    expose :name
    expose :type
    expose :is_checked
    expose :position

    expose :icon, expose_nil: false
    expose :color, expose_nil: false
    expose :buffer_radius, expose_nil: false
    expose :difference_layer, expose_nil: false
    expose :heatmaps, expose_nil: false
    expose :geometry_type, expose_nil: false
    expose :service_metric_id, if: lambda { |metric| metric['service_metric_id'] } do |metric|
      metric&.service_metric_id&.to_s
    end

    expose :heatmap_id, if: lambda { |metric| metric['heatmap_id'] } do |metric|
      metric&.heatmap_id&.to_s
    end

  end

  class ServiceMetric < ::Grape::Entity
    expose :icon
    expose :color
    expose :buffer_radius
    expose :service_metric_id do |metric| metric.service_metric_id.to_s end
    expose :difference_layer
    expose :heatmaps
    expose :geometry_type
  end

  class HeatmapMetric < ::Grape::Entity

  end


end
