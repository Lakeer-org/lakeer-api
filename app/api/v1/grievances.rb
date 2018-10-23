module V1
  class Grievances < Grape::API
    version 'v1', using: :path, vendor: 'twitter'
    format :json
    prefix :api
    helpers Base::AuthHelper

    resource :grievances do
      before do
        authenticate!
      end

      desc 'Get geo-json of a department'
      params do
        requires :grievance_type, type: String, desc: "Grievance type"
        optional :ward_name, type: String, desc: "Ward name"
        optional :circle_name, type: String, desc: "Circle name"
      end
      get '/' do
        grievance = Grievance.first
        present grievance, with: Entities::GrievanceMetrics::Base, grievance_type: params[:grievance_type],
          ward_name: params[:ward_name], circle_name: params[:circle_name]
      end

    end
  end
end
