module V1::Entities::ApiKeys

  class Base < ::Grape::Entity
    expose :token do |obj, opts|
      opts[:token]
    end
    expose :email
    expose :first_name
    expose :last_name
    expose :gender
  end

end
