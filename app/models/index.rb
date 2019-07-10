class Index
  include Mongoid::Document

  has_many :child_groups, dependent: :delete_all, class_name: "Group"
  has_many :child_metrics, dependent: :delete_all, class_name: "IndexMetric"

  belongs_to :owner, class_name: "User"
  has_and_belongs_to_many :shared_to, class_name: "User"

  field :name, type: String
  field :description, type: String
  field :is_recommended, type: Boolean, default: false
  field :boundaries, type: Array



end
