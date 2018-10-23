module Base
  class Authentication < Grape::API
    version 'v1', using: :path, vendor: 'twitter'
    format :json
    prefix :api
    helpers Base::AuthHelper

    resource :auth do

      desc "Creates and returns access_token if valid login"
      params do
        requires :email, type: String, desc: "Username or email address"
        requires :password, type: String, desc: "Password"
      end
      post :login do
        user = User.where(email: params[:email]).first
        if user.present? && user.valid_password?(params[:password])
          if user.api_keys.present? && user.api_keys.last.expired?
            key = user.api_keys.create
          else
            if user.api_keys.exists?
              key = user.api_keys.last
            else
              key = user.api_keys.create
            end
          end
          present user, with: V1::Entities::ApiKeys::Base, token: key.access_token
        else
          error!("Please check your email or password", 401)
        end
      end

      desc "Checks that the user is logged_in correctly"
      get :verify_token do
        if current_user
          {status_message: 'valid'}
        else
          {status_message: 'not_valid', message: 'Not a valid token'}
        end
      end

      desc "User forgot password"
      params do
        optional :user, type: Hash do
          requires :email, type: String, desc: "Email of the registered user"
          requires :action_url, type: String, desc: "Reset password url"
        end
      end
      get :forgot_password do
        user = User.find_by(email: params[:user][:email])
        if user.present?
          user.set_password_reset_token(params[:user][:action_url])
          {status_message: 'Forgot password email sent to your email-id successfully.'}
        else
          error!("User not found", 404)
        end
      end

      desc "Reset password"
      params do
        requires :reset_password_token, type: String, desc: "Reset password token"
        requires :password, type: String, desc: "New password"
        requires :password_confirmation, type: String, desc: "Confirm password"
      end
      patch :reset_password do
        user = User.where(:reset_password_token.ne => nil).where(reset_password_token: params[:reset_password_token]).first
        if user.present?
          if params[:password] == params[:password_confirmation]
            user.update(password: params[:password], reset_password_token: nil)
            {status_message: 'Password updated succesfully'}
          else
            error!("Please enter the confirmation password same as new password", 401)
          end
        else
          error!("Token is expired or invalid.", 401)
        end
      end

    end
  end
end
