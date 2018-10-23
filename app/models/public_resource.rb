class PublicResource
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :name
  field :crs

  has_many :resource_details, inverse_of: :public_resource, dependent: :destroy

end
