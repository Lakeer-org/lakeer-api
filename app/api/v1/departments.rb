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
        optional :numpoint_type, type: String, desc: "Numpoint type"
        optional :service_metric_hole_names, type: Array[String], desc: "The name of the service metrics that will be used to create holes on the returned department", documentation: { param_type: 'query' }
        optional :radius, type: Float, desc: "Radius of buffer"

      end
      get '/' do
        begin
          department = Department.find_by(name: params[:department_name])
          if params[:service_metric_hole_names] && params[:radius]
            my_data = department.levels_with_service_metric_holes(params[:service_metric_hole_names], params[:radius], params[:type])
            present my_data
          else
            present department, with: Entities::Departments::Base, type: params[:type], numpoint_type: params[:numpoint_type]
          end
        rescue Mongoid::Errors::DocumentNotFound => e
          error!({ error: 'Not found', detail: e.message }, 404)
        end
      end
    end

  #   resource :departments_with_holes do
  #     before do
  #       authenticate!
  #     end
  #
  #     desc 'Get geo-json of a department'
  #     params do
  #       requires :department_name, type: String, desc: "Department name"
  #       requires :type, type: String, desc: "Department type"
  #       requires :buffer_radius, type: Integer, desc: "Buffer radius around each point"
  #       requires :type, type: String, desc: "Department type"
  #       optional :numpoint_type, type: String, desc: "Numpoint type"
  #
  #     end
  #     get '/' do
  #       department = Department.find_by(name: params[:department_name])
  #       present department, with: Entities::Departments::Base, type: params[:type]  #, numpoint_type: params[:numpoint_type]
  #     end
  #   end
  end
end
