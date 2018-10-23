class Group
  include Mongoid::Document

  belongs_to :index, inverse_of: :groups
  belongs_to :parent_group, inverse_of: :subgroups, class_name: "Group", optional: true
  has_many :submetrics, class_name: 'IndexMetric', before_add: :set_index, dependent: :delete_all
  has_many :subgroups, class_name: 'Group', before_add: :set_index, dependent: :delete_all

  field :name, type: String
  field :is_checked, type: Boolean, default: true
  field :position, type: Integer

  index({ index: 1, parent_group: 1, position: 1 }, { unique: true, name: "position_index" })

  before_create :set_position
  before_destroy :decrease_sister_positions

  def check(status = !is_checked)
    subgroups.each do |subgroup|
      subgroup.check(status)
    end
    submetrics.each do |submetric|
      submetric.check(status)
    end
    self.is_checked = status
    save
  end

  def move(dest_parent, dest_position)
    # decrease position of all older sister nodes
    decrease_sister_positions
    # increase position of all new sister nodes at the destination point
    index.groups.where(parent_group: dest_parent, :position.gte => dest_position).each do |new_sister|
      new_sister.position += 1
      new_sister.save
    end
    self.position = dest_position
    self.parent_group = dest_parent
    save
  end

  private

  def set_position
    self.position ||= index.groups.where(parent_group: parent_group).count + 1
  end

  def set_index(child)
    child.index = index
  end

  def decrease_sister_positions
    index.groups.where(parent_group: parent_group, :position.gt => position).each do |old_sister|
      old_sister.position -= 1
      old_sister.save
    end
  end
end
