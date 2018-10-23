module V1::Entities::Users

  class Base < ::Grape::Entity
    expose :email
    expose :first_name
    expose :last_name
    expose :gender
  end

end
