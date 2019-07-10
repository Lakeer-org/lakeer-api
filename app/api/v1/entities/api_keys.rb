module V1::Entities::ApiKeys

  class Base < ::Grape::Entity
    expose :token do |obj, opts|
      opts[:token]
    end
    expose :email
    expose :first_name
    expose :last_name
    expose :gender
    expose :user_id do |user| user._id.to_s end
  end

end
