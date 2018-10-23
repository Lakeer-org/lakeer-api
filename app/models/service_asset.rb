class ServiceAsset
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial

  # fields
  field :asset_id
  field :name
  field :ward_name
  field :circle_name
  field :location, type: Point, spatial: true
  field :asset_type
  field :properties

  belongs_to :service_metric, inverse_of: :service_assets
  embeds_one :geometry, as: :geometral

  scope :filtered_coordinates, -> { where(:geometry.ne => nil)}

  def get_basic_properties
    property = Hash.new
    if asset_type == 'toilet'
      property['name'] = name
      property['toilet_id'] = properties["TOILLET_ID"]
      property['business_name'] = properties["BUSINESS_NAME"]
      property['primary_category'] = properties["PRIMARY_CATEGORY"]
      property['fee'] = properties["FEE"]
    elsif asset_type == 'school'
      property['name'] = properties["SCHOOL NAME"]
      property['school_id'] = properties["SCHCD"]
      property['school_category'] = properties["SCHOOL CATEGORY"]
      property['address'] = properties["Concatanated Address"]
    else
      property['name'] = name
    end
    property['type'] = asset_type.titleize
    property
  end

end
