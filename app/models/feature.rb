class Feature
  include Mongoid::Document
  include Mongoid::Timestamps

  field :type, type: String
  field :properties, type: Hash

  embeds_one :geometry, as: :geometral
  embedded_in :feature_collection, polymorphic: true


end
