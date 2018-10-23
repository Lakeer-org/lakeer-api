module V1::Entities::Departments

  class Base < ::Grape::Entity
    expose :type do |obj, opts|
      "FeatureCollection"
    end
    expose :levels, as: :features, with: 'V1::Entities::Departments::Level' do |obj, opts|
      obj.levels.where(level_type: opts[:type])
    end
  end

  class Level < ::Grape::Entity
    expose :type do |obj, opts|
      "Feature"
    end
    expose :properties do |obj, opts|
      # numpoint_distribution = obj.numpoint_distributions.where(numpoint_type: opts[:numpoint_type]).first
      property = Hash.new
      property['name'] = obj.name.tr("-0-9-", "").downcase.titleize
      property['type'] = obj.level_type
      # property['numpoints'] = numpoint_distribution.numpoint_count
      # property['numpoint_type'] = numpoint_distribution.numpoint_type
      property
    end
    expose :geometry, with: 'V1::Entities::Departments::Geometry'

  #   expose :level_with_holes do |obj, metric_names, buffer_radius, level_type|
  #     obj.levels_with_service_metric_holes(metric_names, buffer_radius, level_type)
  #   end
  # end
  end
  class Geometry < ::Grape::Entity
    expose :type
    expose :coordinates
  end
end
