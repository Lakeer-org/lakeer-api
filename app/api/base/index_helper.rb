module Base
  module IndexHelper
    extend Grape::API::Helpers
    def create_children(parent, child_groups, child_metrics)
      child_groups&.each_with_index do |child_group, i|
        new_group = _create_group(parent, child_group, i + 1)
        create_children(new_group, child_group['child_groups'], child_group['child_metrics'])
      end

      child_metrics&.each_with_index do |child_metric, i|
        _create_metric(parent, child_metric, i + 1)
      end
    end

    def _create_group(parent, group, position)
      parent.child_groups.create!(
        name: group['name'],
        position: position,
        is_checked: group['is_checked']
      )
    end

    def _create_metric(parent, metric, position)
      type = metric['type'] || 'service'
      print(type)
      common_args = {
        name: metric['name'],
        type: type,
        position: position,
        is_checked: metric['is_checked']
      }
      new_metric =
        if type == 'service' || type == 'metric' # TODO: change the frontend to make this only service
          extra_args = {
            color: metric['color'].downcase,
            icon: metric['icon'],
            buffer_radius: metric['buffer_radius'],
            service_metric_id: metric['service_metric_id'],
            difference_layer: metric['difference_layer'],
            heatmaps: metric['heatmaps'],
            geometry_type: metric['geometry_type']
          }
          p("IDDQD")
          p(common_args)
          p(extra_args)
          asd = common_args.merge(extra_args)
          p(asd)
          IndexServiceMetric.create(asd)
        elsif type == 'heatmap'
          extra_args = {
            heatmap: Heatmap.find(metric['heatmap_id'])
          }
          HeatmapServiceMetric.create(attributes: common_args.merge(extra_args))
        end
      p("======")
      p(new_metric)
      p("jshdhakd")
      parent.child_metrics << new_metric
    end
  end
end
