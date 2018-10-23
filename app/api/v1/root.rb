module V1
  class Root < Grape::API

    insert_after Grape::Middleware::Formatter, Grape::Middleware::Logger
    mount V1::Departments
    mount V1::Indices
    mount V1::Grievances
    mount V1::PublicResources
    mount V1::ServiceMetrics
    mount V1::Users
  end
end
