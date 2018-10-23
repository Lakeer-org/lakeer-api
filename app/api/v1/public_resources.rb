module V1
  class PublicResources < Grape::API
    version 'v1', using: :path, vendor: 'twitter'
    format :json
    prefix :api
    helpers Base::AuthHelper

    resource :public_resources do
      before do
        authenticate!
      end

      desc 'Get geo-json of a Public Resource'
      params do
        optional :resource_name, type: String, desc: "Resource name"
        optional :resource_type, type: String, desc: "Asset type"
      end
      get '/' do
        public_resource = PublicResource.find_by(name: params[:resource_name])
        present public_resource, with: Entities::PublicResources::Base, resource_type: params[:resource_type]
      end

    end
  end
end
