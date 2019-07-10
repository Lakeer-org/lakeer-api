class FeatureCollection
  include Mongoid::Document

  field :type, type: String, default: 'FeatureCollection'
  embeds_many :features, as: :feature_collection

end
