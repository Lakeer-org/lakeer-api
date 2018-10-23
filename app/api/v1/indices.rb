module V1
  class Indices < Grape::API
    helpers Base::AuthHelper
    helpers Base::IndexHelper
    format :json

    resource :indices do
      before do
        authenticate!
      end


      desc "Get an user's indices"
      get do
        present current_user.indices.all, with: Entities::Indices::Base
      end


      desc "Create a new index"
      format :json
      params do
        requires :name, type: String, desc: "Name of the Index", documentation: {param_type: 'body'}
        requires :subgroups, type: Array[JSON], desc: "Children groups", documentation: {param_type: 'body'} do
          requires :name, desc: "Name of the group", documentation: {param_type: 'body'}
          requires :subgroups, type: Array[JSON], desc: "Children", documentation: {param_type: 'body'}
        end
      end
      post do
        index = current_user.indices.create(name: params[:name])
        create_root_groups(index, params[:subgroups])
        present index, with: Entities::Indices::Base
      end


      route_param :id do
        desc 'Get an specific index'
        get do
          present current_user.indices.find(params[:id]), with: Entities::Indices::Base
        end
        desc 'Replace the contents of an index'
        params do
          requires :subgroups, type: Array[JSON], desc: "Children groups", documentation: {param_type: 'body'} do
            requires :name, desc: "Name of the group", documentation: {param_type: 'body'}
            requires :subgroups, type: Array[JSON], desc: "Children", documentation: {param_type: 'body'}
          end
        end
        put do
          index = current_user.indices.find(params[:id])
          index.groups.delete_all
          create_root_groups(index, params[:subgroups])
          present index, with: Entities::Indices::Base
        end
      end


    end
  end
end
