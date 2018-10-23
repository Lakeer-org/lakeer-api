class ServiceCategory
  include Mongoid::Document
  include Mongoid::Timestamps

  # Fields
  field :name

  has_many :services, inverse_of: :service_category, dependent: :destroy
end
