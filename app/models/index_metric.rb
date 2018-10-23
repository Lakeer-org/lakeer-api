class IndexMetric
  include Mongoid::Document

  belongs_to :index, inverse_of: :metrics
  belongs_to :parent_group, inverse_of: :submetrics, class_name: "Group", optional: true

  field :name, type: String
  field :is_checked, type: Boolean, default: true
  field :position, type: Integer, default: ->{ index.metrics.where(parent_group: parent_group).count + 1}

  def check(status = !is_checked)
    self.is_checked = status
  end

  def move(dest_parent, dest_position)
    # decrease position of all older sister nodes
    index.metrics.where(parent_group: self.parent_group, :position.gt => self.position).each do |old_sister|
      old_sister.position -= 1
    end
    index.metrics.where(parent_group: self.parent_group, :position.gte => self.position).each do |new_sister|
      new_sister.position += 1
    end
    self.position = dest_position
    self.parent = dest_parent
  end

end
