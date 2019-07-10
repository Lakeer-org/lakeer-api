class EnvironmentCategory
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name
  field :category
  field :properties

  belongs_to :environment, inverse_of: :environment_category
  embeds_one :geometry, as: :geometral  
end
