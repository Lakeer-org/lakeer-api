class ServiceMetric
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :name
  field :crs


  belongs_to :service, inverse_of: :service_metric
  has_many :service_assets, inverse_of: :service_metric, dependent: :destroy

end
