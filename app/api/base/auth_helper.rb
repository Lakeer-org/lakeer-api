module Base
  module AuthHelper
    extend Grape::API::Helpers
    def authenticate!
      error!('Unauthorized. Invalid or expired token.', 401) unless current_user
    end

    def current_user
      # find token. Check if valid.
      if (matches = /Bearer ([A-Za-z0-9]*)/.match(headers['Authorization']))
        token = ApiKey.where(access_token: matches[1]).first
      end
      if token.present? && !token.expired?
        @current_user = token.user
      else
        false
      end
    end
  end
end
