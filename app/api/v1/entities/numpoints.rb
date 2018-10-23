module V1::Entities::Numpoints

  class Base < ::Grape::Entity
    expose :name do |obj, opts|
      obj.name.tr("-0-9-", "").downcase.titleize
    end
    expose :level_type do |obj, opts|
      obj.level_type
    end
    expose :numpoint_count do |obj, opts|
      if opts[:type] == 'grievance'
        coordinates = obj.geometry.coordinates
        ::Grievance.collection.find({grievance_type: opts[:service_type], location: { "$geoWithin" => { "$polygon" => coordinates.flatten(2) }}}).count
      elsif opts[:type] == 'service_asset'
        coordinates = obj.geometry.coordinates
        ::ServiceAsset.collection.find({asset_type: opts[:service_type], location: { "$geoWithin" => { "$polygon" => coordinates.flatten(2) }}}).count        
      end
    end
  end
end
