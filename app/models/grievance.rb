class Grievance
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Geospatial

  # fields
  field :grievance_type
  field :ward_name
  field :circle_name
  field :location, type: Point, spatial: true
  field :complaint_id
  field :status
  field :category
  field :sub_category
  field :remark

  spatial_scope :location

  embeds_one :geometry, as: :geometral

  scope :grievance_type_filter, lambda {|grievance_type|
    return nil if grievance_type.blank?
    where(:geometry.ne => nil, grievance_type: grievance_type)
  }

  scope :ward_filter, lambda {|ward_name|
    return nil if ward_name.blank?
    where(ward_name: ward_name)
  }

  scope :circle_filter, lambda {|circle_name|
    return nil if circle_name.blank?
    where(circle_name: circle_name)
  }

end
