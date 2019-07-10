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

      desc "Get an recommendeds indices"
      get 'recommended' do
        present Index.where(is_recommended: true), with: Entities::Indices::Base
      end


      desc "Create a new index"
      format :json
      params do
        requires :name, type: String, desc: "Name of the Index", documentation: {param_type: 'body'}
        optional :description, type: String, desc: "Description of the index", documentation: {param_type: 'body'}
        requires :boundaries, type: Array[JSON], desc: "Boundaries of the index", documentation: {param_type: 'body'}
        optional :child_groups, type: Array[JSON], desc: "Children groups", documentation: {param_type: 'body'} do
          requires :name, desc: "Name of the group", documentation: {param_type: 'body'}
          optional :is_checked, type: Boolean, desc: "If the group is checked or unchecked for viewing", documentation: {param_type: 'body'}
          optional :child_groups, type: Array[JSON], desc: "Children subgroups", documentation: {param_type: 'body'}
          optional :child_metrics, type: Array[JSON], desc: "Children submetrics", documentation: {param_type: 'body'}
        end
        optional :child_metrics, type: Array[JSON], desc: "Children metrics", documentation: {param_type: 'body'} do
          requires :name, desc: "Name of the metric", documentation: {param_type: 'body'}
          # requires :type, desc: "Type of the metric", documentation: {param_type: 'body'}
          optional :is_checked, type: Boolean, desc: "If the metric is checked or unchecked for viewing", documentation: {param_type: 'body'}
          optional :icon, desc: "The inner SVG of the icon", documentation: {param_type: 'body', default: '<circle cx="5" cy="5" r="5" fill="blue" />'}
          optional :color, desc: "The HEX color of the icon", documentation: {param_type: 'body'}
          optional :buffer_radius, type: Float, desc: "Radius of the buffer that will be created around each point", documentation: {param_type: 'body'}
          optional :service_metric_id, desc: "ID of the service metric that will provide the points", documentation: {param_type: 'body'}
        end
      end
      post do
        index = current_user.indices.create(
          name: params[:name],
          description: params[:description],
          boundaries: params[:boundaries],
        )
        create_children(index, params[:child_groups], params[:child_metrics])
        present index, with: Entities::Indices::Base
      end


      route_param :id do
        desc 'Get an specific index'
        get do
          index = Index.find(params[:id])
          if index.owner_id == current_user.id || index.is_recommended
            present index, with: Entities::Indices::Base
          else
            raise Mongoid::Errors::DocumentNotFound
          end
        end
        desc 'Replace the contents of an index'
        params do
          requires :name, type: String, desc: "Name of the Index", documentation: {param_type: 'body'}
          requires :boundaries, type: Array[JSON], desc: "Boundary of the index", documentation: {param_type: 'body'}
          optional :description, type: String, desc: "Description of the index", documentation: {param_type: 'body'}
          optional :child_groups, type: Array[JSON], desc: "Children groups", documentation: {param_type: 'body'} do
            requires :name, desc: "Name of the group", documentation: {param_type: 'body'}
            optional :is_checked, type: Boolean, desc: "If the group is checked or unchecked for viewing", documentation: {param_type: 'body'}
            optional :child_groups, type: Array[JSON], desc: "Children subgroups", documentation: {param_type: 'body'}
            optional :child_metrics, type: Array[JSON], desc: "Children submetrics", documentation: {param_type: 'body'}
          end
          optional :child_metrics, type: Array[JSON], desc: "Children metrics", documentation: {param_type: 'body'} do
            requires :name, desc: "Name of the metric", documentation: {param_type: 'body'}
            optional :is_checked, type: Boolean, desc: "If the metric is checked or unchecked for viewing", documentation: {param_type: 'body'}
            optional :icon, desc: "The inner SVG of the icon", documentation: {param_type: 'body'}
            optional :color, desc: "The HEX color of the icon", documentation: {param_type: 'body'}
            optional :buffer_radius, type: Float, desc: "Radius of the buffer that will be created around each point", documentation: {param_type: 'body'}
            optional :service_metric_id, desc: "ID of the service metric that will provide the points", documentation: {param_type: 'body'}
          end
        end
        put do
          index = current_user.indices.find(params[:id])
          index.name = params[:name]
          index.boundaries = params[:boundaries]
          index.description = params[:description]
          index.child_groups.delete_all
          index.child_metrics.delete_all
          # Calls helper method
          create_children(index, params[:child_groups], params[:child_metrics])
          index.save!
          present index, with: Entities::Indices::Base
        end
        delete do
          index = current_user.indices.find(params[:id])
          if index
            index.destroy
            status 204
          else
            raise Mongoid::Errors::DocumentNotFound
          end
        end
      end


    end
  end
end
