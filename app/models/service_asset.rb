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

  scope :filtered_coordinates, -> { where('geometry.type' => { '$ne' => nil})}

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
    elsif asset_type == 'plants'
      if self.service_metric.name == 'nurseries'
        property["name"] = properties["Name of the Nursery"]
        property["Area in acres"] = properties["Area in acres"]
        property["Nursery Incharge"] = properties["Nursery Incharge"]
        property["Contact No"] = properties["Contact No"]
      elsif self.service_metric.name == "planted_plants"
        property['name'] = properties['Location']
        property["No of Plants Planted"] = properties["No of Plants Planted"]
        property["No of Plants Survived"] = properties["No of Plants Survived"]
        if properties["No of Plants Survived"].to_i == 0
          property["Survival percentage"] = 0
        else
          property["Survival percentage"] = ((properties["No of Plants Survived"].to_f / properties["No of Plants Planted"].to_f) * 100).round()
        end
      elsif self.service_metric.name == 'survived_plants'
        property['name'] = properties['location']
        property['Survival percentage'] = properties["Survival %"]
      end
    elsif asset_type == 'fair_price_shop'
      property['name'] = properties['Location']
    elsif asset_type == 'kanti_velugu'
      property['name'] = properties['Camp']
      property['ward'] = properties['Ward']
      property['city'] = properties['City']
      property['location'] = properties['Location']
    elsif asset_type == 'rehab_center'
      property['name'] = properties['Rehabilitation centre identified']
      property['location'] = properties['Name of the Mandal']
      property['In charge'] = properties['Name of the incharge person with Mobile No']
    elsif asset_type == 'vulnerable_localities'
      property['location'] = properties['Name of Vulnerable locality']
      property['Mandal Name'] = properties['Name of the Mandal']
      property['No. of families estimated to be effected'] = properties['No. of families estimated to be effected']
      property['Rehabilitation centre identified'] = properties['Rehabilitation centre identified']
      property['Time for water to recede'] = properties['Time for water to recede']
    else
      property['name'] = name
    end
    property['type'] = asset_type&.titleize
    property
  end

end
