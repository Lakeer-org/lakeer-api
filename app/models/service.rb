class Service
  include Mongoid::Document
  include Mongoid::Timestamps
  validates :service_type, presence: true
  # fields
  field :service_type
  field :position, type: Integer
  field :is_visible, type: Boolean, default: true

  belongs_to :service_category, inverse_of: :service
  has_many :service_metrics, inverse_of: :service, dependent: :destroy

  scope :only_visible, -> {where(is_visible: true)}
end
