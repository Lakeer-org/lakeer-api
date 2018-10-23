class Service
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :service_type

  belongs_to :service_category, inverse_of: :service
  has_many :service_metrics, inverse_of: :service, dependent: :destroy
end
