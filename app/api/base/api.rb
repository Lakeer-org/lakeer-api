require 'grape-swagger'
module Base
  class API < Grape::API
    prefix :api
    format :json
    default_format :json
    version :v1
    rescue_from Mongoid::Errors::Validations do |error|
      detail = "#{error.summary}. #{error.resolution}"
      error!({ error: error.problem, detail: detail }, 422)
    end
    rescue_from Mongoid::Errors::DocumentNotFound do |error|
      error!({ error: 'Not found', detail: error.message }, 404)
    end
    mount Base::Authentication
    mount V1::Root

    add_swagger_documentation \
      mount_path: '/swagger_doc',
      array_use_braces: true

  end
end
