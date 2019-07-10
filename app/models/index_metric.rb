class IndexMetric
  include Mongoid::Document

  before_create :set_position
  before_validation { color&.downcase! }
  before_destroy :decrease_sister_positions

  belongs_to :index, inverse_of: :child_metrics
  belongs_to :parent_group, inverse_of: :child_metrics, class_name: 'Group', optional: true

  field :name, type: String
  field :type, type: String
  field :is_checked, type: Boolean, default: true
  field :position, type: Integer

  def check(status = !is_checked)
    self.is_checked = status
    save
  end

  def move(dest_parent, dest_position)
    # decrease position of all older sister nodes
    decrease_sister_positions
    # increase position of all new sister nodes at the destination point
    index.metrics.where(parent_group: dest_parent, :position.gte => dest_position).each do |new_sister|
      new_sister.position += 1
      new_sister.save
    end
    self.position = dest_position
    self.parent_group = dest_parent
    save
  end

  private

  # Before create: If a position value has not been provided, it sets it
  def set_position
    self.position ||= index.metrics.where(parent_group: parent_group).count + 1
  end

  def set_index(child)
    child.index = index
  end

  def decrease_sister_positions
    index.metrics.where(parent_group: parent_group, :position.gt => position).each do |old_sister|
      old_sister.position -= 1
      old_sister.save
    end
  end
end
