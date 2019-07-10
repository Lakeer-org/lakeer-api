module V1::Entities::Departments

  class Base < ::Grape::Entity
    expose :type do |obj, opts|
      "FeatureCollection"
    end
    expose :properties do |obj, opts|
      {name: obj[:name]}
    end
    expose :levels, as: :features do |obj, opts|
      params = opts[:params]
      levels =
        if params[:difference_layer_ids] && params[:difference_layer_radii]
          obj.levels_with_service_metric_holes(
            params[:difference_layer_ids],
            params[:difference_layer_radii],
            params[:type]
          )
        else
          obj.levels.where(level_type: params[:type])
        end
      puts params
      Level.represent levels, opts.merge(
        boundary: obj[:name], heatmap_id: params[:heatmap_id], heatmap_type: params[:heatmap_type]
      )
    end
  end

  class Level < ::Grape::Entity
    expose :type do |obj, opts|
      "Feature"
    end
    expose :properties do |obj, opts|
      # numpoint_distribution = obj.numpoint_distributions.where(numpoint_type: opts[:numpoint_type]).first
      property = Hash.new
      property['name'] = obj[:name].tr("-0-9-", "").downcase.titleize
      property['level'] = obj[:level_type]
      property['boundary'] = opts[:boundary]
      property['population'] = obj[:population]
      property['total_expenditure'] = obj[:total_expenditure]
      property['person_nominated'] = obj[:person_nominated]
      property['no_of_operational_ward'] = obj[:no_of_operational_ward]
      property['chairperson'] = obj[:chairperson]
      property['area_sabha_members'] = obj[:members]
      property['numpoints'] =
        case opts[:heatmap_type]
        when "service"
          service_metric = ServiceMetric.find(opts[:heatmap_id])
          begin
            service_metric.service_assets
              .where(
                location: { '$geoWithin' =>
                  { '$polygon' => obj[:geometry][:coordinates].flatten(2) } }
              ).pluck(:location).uniq.count  # Pluck of location added because query results same location multiple times
          rescue
            service_metric.service_assets
              .where(
                location: { '$geoWithin' =>
                  { '$polygon' => obj[:geometry][:coordinates].flatten(1) } }
              ).count
          end
        when "heatmap"
          heatmap = Heatmap.find(opts[:heatmap_id])
          query = :"properties.location.#{obj[:level_type].downcase}"
          puts query
          puts opts[:boundary]
          puts obj[:name]
          features = heatmap.features.where(query => obj[:name])
          puts features.count
          count = features.map do |feature|
            puts feature.properties
            feature.properties['value']&.to_d || 0 # BUG: Some values are turning up empty, that should be fixed
          end.reduce(:+)
          puts count
          count
        end
      property
    end
    expose :geometry, with: 'V1::Entities::Departments::Geometry'
  end

  class Geometry < ::Grape::Entity
    expose :type
    expose :coordinates
  end

end
