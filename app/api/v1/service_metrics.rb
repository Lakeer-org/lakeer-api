module V1
  class ServiceMetrics < Grape::API
    version 'v1', using: :path, vendor: 'twitter'
    format :json
    prefix :api
    helpers Base::AuthHelper

    resource :service_metrics do
      before do
        authenticate!
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

      desc 'Get geo-json of a basic-service'
      params do
        requires :service_type, type: String, desc: "Filter using service type"
        requires :level_type, type: String, desc: "Filter by level_type"
      end
      get '/numpoints' do
        level_ids = Level.where(level_type: params[:level_type]).pluck(:id)
        numpoints = NumpointDistribution.where(numpoint_type: params[:service_type]).where(:level_id.in => level_ids)
        present numpoints, with: Entities::ServiceMetrics::Numpoints
      end

      desc 'Get geo-json of a basic-service'
      params do
        requires :level_type, type: String, desc: "Filter by level_type"
        optional :service_type, type: String, desc: "Filter using service type"
        optional :type, values: ['service_asset', 'grievance'], desc: "Service or Grievance"
      end
      get '/asset_numpoints' do
        levels = Level.where(level_type: params[:level_type])
        present levels, with: Entities::Numpoints::Base, service_type: params[:service_type], type: params[:type]
      end

    end
  end
end
