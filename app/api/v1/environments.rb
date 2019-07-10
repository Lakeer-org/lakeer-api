module V1
  class Environments < Grape::API
    version 'v1', using: :path, vendor: 'twitter'
    format :json
    prefix :api
    helpers Base::AuthHelper

    resource :environment do
      before do
        authenticate!
      end
            
      desc 'Get geo-json of a Public Resource'
      params do
        optional :name, type: String, desc: "contamination name"
        optional :category, type: String, desc: "contamination type"
      end
      get '/' do
        environment = Environment.find_by(name: params[:name])
        present environment, with: Entities::Environments::Base, category: params[:category]
      end

    end
  end
end
