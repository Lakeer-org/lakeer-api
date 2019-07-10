module V1
  class Departments < Grape::API
    version 'v1', using: :path, vendor: 'twitter'
    format :json
    prefix :api
    helpers Base::AuthHelper

    resource :departments do
      before do
        authenticate!
      end

      desc 'Get geo-json of a department'
      params do
        requires :department_name, type: String, desc: "Department name"
        requires :type, type: String, desc: "Department type"
        optional :difference_layer_ids, type: Array[String], desc: "The name of the service metrics that will be used to create holes on the returned department", documentation: { param_type: 'query' }
        optional :difference_layer_radii, type: Array[Float], desc: "Radii of the difference layers", documentation: { param_type: 'query' }
        optional :heatmap_id, type: String, desc: 'ID of the heatmap metric', documentation: { param_type: 'query' }
        optional :heatmap_type, type: String, desc: 'Type of the metric that will be used to calculate the heatmap values, either a service_metric or a heatmap'
      end
      get '/' do
        begin
          department = Department.find_by(name: params[:department_name])
          print(params[:difference_layer_ids])
          print(params[:difference_layer_radii])
          present department, with: Entities::Departments::Base, params:params, type: params[:type]
        rescue Mongoid::Errors::DocumentNotFound => e
          error!({ error: 'Not found', detail: e.message }, 404)
        end
      end
    end
  end
end
