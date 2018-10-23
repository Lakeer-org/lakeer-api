require 'grape-swagger'
module Base
  class API < Grape::API
    prefix :api
    format :json
    default_format :json
    version :v1
    mount Base::Authentication
    mount V1::Root

    add_swagger_documentation \
      mount_path: '/swagger_doc',
      array_use_braces: true

  end
end
