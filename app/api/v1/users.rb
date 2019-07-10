module V1
  class Users < Grape::API
    version 'v1', using: :path, vendor: 'twitter'
    format :json
    prefix :api
    helpers Base::AuthHelper

    resource :users do
      before do
        authenticate!
      end

      desc 'Edit User'
      params do
        optional :first_name, type:String, desc: "User's first name"
        optional :last_name, type:String, desc: "User's first name"
        optional :gender, values: ['male', 'female'], desc: "User's Gender"
      end
      patch '/update' do
        if current_user.update_attributes(params.except('token'))
          present current_user, with: Entities::Users::Base
        else
          error!(user.errors , 422)
        end
      end

      desc 'User request callback'
      params do
        requires :name, type:String, desc: "User full name"
        requires :mobile_number, type:String, desc: "Mobile number for callback"
        optional :reason_for_call, type:String, desc: "Reason for callback"
      end
      post '/request-callback' do
        RequestCallbackJob.perform_later(params[:name], params[:mobile_number], params[:reason_for_call])
      end

    end
  end
end
