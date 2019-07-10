class ServiceMetric
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :name, type: String
  field :crs
  field :description, type: String
  field :display_name, type: String
  field :data_source
  field :data_verification
  field :vintage
  field :position, type: Integer
  field :is_visible, type: Boolean, default: true
  field :metric_type, type: String, default: "service"


  belongs_to :service, inverse_of: :service_metric
  has_many :service_assets, inverse_of: :service_metric, dependent: :destroy

  scope :only_visible, -> {where(is_visible: true)}

  def self.to_csv
    attributes = %w{id name crs description display_name data_source data_verification vintage position}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
end
