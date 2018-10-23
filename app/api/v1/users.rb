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

    end
  end
end
