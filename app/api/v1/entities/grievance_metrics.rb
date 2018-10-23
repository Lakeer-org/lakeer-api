module V1::Entities::GrievanceMetrics

  class Base < ::Grape::Entity
    expose :type do |obj, opts|
      "FeatureCollection"
    end
    expose :features, with: 'V1::Entities::GrievanceMetrics::Grievance' do |obj, opts|
      ::Grievance.grievance_type_filter(opts[:grievance_type]).ward_filter(opts[:ward_name]).circle_filter(opts[:circle_name])
    end
  end

  class Grievance < ::Grape::Entity
    expose :type do |obj, opts|
      "Feature"
    end
    expose :properties do |obj, opts|
      property = Hash.new
      property['type'] = obj.grievance_type
      property['category'] = obj.category
      property['sub_category'] = obj.sub_category
      property['remark'] = obj.remark
      property
    end
    expose :geometry, as: :geometry
  end

  class Geometry < ::Grape::Entity
    expose :type
    expose :coordinates
  end
end
