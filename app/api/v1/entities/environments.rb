module V1::Entities::Environments

  class Base < ::Grape::Entity
    expose :type do |obj, opts|
      "FeatureCollection"
    end
    expose :environment_categories, as: :features, with: 'V1::Entities::Environments::EnvironmentCategory' do |obj, opts|
      obj.environment_categories.where(category: opts[:category])
    end
  end

  class EnvironmentCategory < ::Grape::Entity
    expose :type do |obj, opts|
      "Feature"
    end
    expose :properties
    expose :geometry do |obj, opts|
      obj.geometry
    end
  end

  class Geometry < ::Grape::Entity
    expose :type
    expose :coordinates
  end

end
