class ResourceDetail
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :resource_type
  field :properties

  belongs_to :public_resource, inverse_of: :resource_detail
  embeds_one :geometry, as: :geometral

end
