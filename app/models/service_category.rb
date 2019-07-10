class ServiceCategory
  include Mongoid::Document
  include Mongoid::Timestamps

  validates :name, presence: true
  # Fields
  field :name
  field :position, type: Integer
  field :is_visible, type: Boolean, default: true

  has_many :services, inverse_of: :service_category, dependent: :destroy

  scope :only_visible, -> {where(is_visible: true)}
end
