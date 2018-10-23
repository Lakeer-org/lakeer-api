class Geometry
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type
  # type should be a `point`, `multipolygon` or stuff like that
  field :coordinates

  embedded_in :geometral, polymorphic: true
  # belongs_to :level,  inverse_of: :geometry
  # belongs_to :service_region, inverse_of: :geometry

  scope :points, -> {where(type: 'Point') }
  scope :multipolygons, -> {where(type: 'MultiPolygon') }

end
