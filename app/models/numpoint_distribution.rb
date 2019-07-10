class NumpointDistribution
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :numpoint_count
  field :numpoint_type
  field :properties  

  belongs_to :level, inverse_of: :numpoint_distribution
end
