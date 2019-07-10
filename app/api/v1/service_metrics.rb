module V1
  class ServiceMetrics < Grape::API
    version 'v1', using: :path, vendor: 'twitter'
    format :json
    prefix :api
    helpers Base::AuthHelper

    resource :heatmaps do
      before do
        authenticate!
      end


      desc 'Get list of all heatmap metrics'
      get do
        heatmaps = Heatmap.all()
        pp('Heatmaps')
        pp(heatmaps.length)
        present heatmaps, with: Entities::ServiceCategories::Heatmap, type: :list
      end

      route_param :id do
        desc 'get a heatmap metric'
        get do
          heatmap = Heatmap.find(params[:id])
          present heatmap, with: Entities::ServiceCategories::Heatmap, type: :detail
        end
      end
    end

    resource :service_metrics do
      before do
        authenticate!
      end

      desc 'Get list of all service metrics'
      get '/list' do
        service_categories = ServiceCategory.only_visible.order(position: :asc)
        present service_categories, with: Entities::ServiceCategories::List
      end

      desc 'Get geo-json of a basic-service'
      params do
        requires :service_category, type: String, desc: "Service Category's name"
        requires :service_type, type: String, desc: "Service type"
        requires :service_metric, type: String, desc: "Service Metric's name"
      end

      get '/' do
        service_metric = ServiceCategory.where(name: params[:service_category]).first
          .services.where(service_type: params[:service_type]).first.service_metrics.where(name: params[:service_metric]).first
        present service_metric, with: Entities::ServiceMetrics::Base
      end

      desc 'Get numpoint count of a basic-service'
      params do
        requires :service_type, type: String, desc: "Filter using service type"
        requires :level_type, type: String, desc: "Filter by level_type"
      end

      get '/numpoints' do
        level_ids = Level.where(level_type: params[:level_type]).pluck(:id)
        numpoints = NumpointDistribution.where(numpoint_type: params[:service_type]).where(:level_id.in => level_ids)
        present numpoints, with: Entities::ServiceMetrics::Numpoints
      end

      desc 'Get numpoint count of a basic-service per level'
      params do
        requires :level_type, type: String, desc: "Filter by level_type"
        optional :service_type, type: String, desc: "Filter using service type"
        optional :type, values: ['service_asset', 'grievance'], desc: "Service or Grievance"
      end
      get '/asset_numpoints' do
        levels = Level.where(level_type: params[:level_type])
        present levels, with: Entities::Numpoints::Base, service_type: params[:service_type], type: params[:type]
      end

      desc 'Get numpoint count of a metric per individual boundary level'
      params do
        requires :boundary_name, type: String, desc: "Filter by level_type"
        requires :boundary_level, type: String, desc: "Filter by level_type"
        optional :service_metric_id, type: String, desc: "Filter using the service metric ID"
      end
      get '/boundary_numpoints' do
        levels = Department.find_by(name: params[:boundary_name]).levels(params[:boundary_level])
        present levels, with: Entities::Numpoints::Boundary
      end

      route_param :id do
        desc 'Get an specific service metric'
        get do
          present ServiceMetric.find(params[:id]), with: Entities::ServiceMetrics::Base
        end
      end



    end
  end
end
