class Department
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :name
  field :crs
  field :type


  has_many :levels, inverse_of: :department, dependent: :destroy

  def levels_with_point_holes(points, buffer_radius, level_type)
    resolution = 16 # This calculates the number of points that the polygonal approximation of a circle will have. A resolution of 16 will generate 32 points
    kilometers_per_degree = 110
    # Creates a RGeo factory that will
    factory = RGeo::Cartesian.preferred_factory(buffer_resolution: resolution)
    coder = RGeo::GeoJSON.coder({geo_factory: factory})
    gjson_points = points.map {|x| {"type" => "Point", "coordinates" => x}}
    rgeo_points = gjson_points.map {|x| coder.decode(x)}
    rgeo_buffers = rgeo_points.map {|x| x.buffer(buffer_radius.to_f/kilometers_per_degree)}
    all_buffers = rgeo_buffers.reduce(:+)
    levels.where(level_type: level_type).map do |level|
      coder.decode(level.geometry.as_json) - all_buffers
    end
  end

  def levels_with_service_metric_holes(metric_names, buffer_radius, level_type)
    resolution = 16 # This calculates the number of points that the polygonal approximation of a circle will have. A resolution of 16 will generate 32 points
    kilometers_per_degree = 110
    # Creates a RGeo factory that will
    factory = RGeo::Cartesian.preferred_factory(buffer_resolution: resolution)
    coder = RGeo::GeoJSON.coder({geo_factory: factory})

    metric_buffers = metric_names.map do |name|
      ServiceMetric.where(name: name).first.service_assets.map do |asset|
        coder.decode(asset.geometry.as_json).buffer(buffer_radius.to_f/kilometers_per_degree)
      end.reduce(:+)
    end.reduce(:+)
    new_features = levels.where(level_type: level_type).map do |level|
      {
        "type" => "Feature",
        "geometry" => coder.encode(coder.decode(level.geometry.as_json) - metric_buffers),
        "properties" => {
          'name' => level.name.tr("-0-9-", "").downcase.titleize + "_with_holes",
          'type' => level.level_type
        }
      }
    end
    return {
      "type" => 'FeatureCollection',
      'features' => new_features
    }
  end

end
