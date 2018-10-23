class Index
  include Mongoid::Document

  has_many :groups, dependent: :delete_all
  has_many :metrics, dependent: :delete_all, class_name: "IndexMetric"

  belongs_to :owner, class_name: "User"
  has_and_belongs_to_many :shared_to, class_name: "User"

  field :name, type: String



end
