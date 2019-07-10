class Environment
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :name
  field :crs

  has_many :environment_categories, inverse_of: :environment, dependent: :destroy

end
