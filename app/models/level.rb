class Level
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :name
  field :level_number
  field :level_type
  field :circle
  field :ward
  field :zone
  field :properties
  field :area, type: Hash
  field :total_expenditure
  field :expenditure_population_ratio
  field :population
  field :person_nominated
  field :no_of_operational_ward
  field :chairperson
  field :area_sabha_members

  belongs_to :department, inverse_of: :levels
  embeds_one :geometry, as: :geometral
  # has_many :numpoint_distributions, inverse_of: :level, dependent: :destroy

  scope :circles, -> {where(level_type: 'Circle') }
  scope :wards, -> {where(level_type: 'Ward') }
  scope :zones, -> {where(level_type: 'Zone') }

end





# circle ["OBJECTID", "Shape_Leng", "Shape_Area", "area_hecta", "ZONE", "CIR_NO", "CIR_NAME", "LATITUDES", "LONGITUDES"]
# zone ["new_zones", "area"]
# ward ["AREA_IN_SQ", "ward", "CIRCLE", "ZONE"]
