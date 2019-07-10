class Heatmap < FeatureCollection
  field :name, type: String
  field :crs, type: Hash
  field :description, type: String
  field :display_name, type: String
  field :department, type: String
  field :metric_type, default: "heatmap"

end
