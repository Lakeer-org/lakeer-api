class IndexServiceMetric < IndexMetric
  include Mongoid::Document

  belongs_to :service_metric

  field :type, type: String, default: 'service'

  field :color, type: String, default: '#037ef3'
  field :icon, type: String, default: 'circle'
  field :buffer_radius, type: Float, default: 0
  field :difference_layer, type: Array, default: []
  field :heatmaps, type: Array, default: []
  field :geometry_type, type: String

  validates :color, format: { with: /\A\#[0-9a-f]{6}\z/, message: "The color must be a hex string"}
  validates :buffer_radius, numericality: { greater_than_or_equal_to: 0 }

end
