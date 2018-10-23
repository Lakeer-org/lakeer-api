module V1::Entities::Indices

  class Base < ::Grape::Entity
    expose :name
    expose :id do |index| index._id.to_s end
    expose :child_groups, with: 'V1::Entities::Indices::Group', unless: {collection: true} do |index|
      index.groups.where(parent_group: nil).order_by(:position.asc)
    end
  end

  class Group < ::Grape::Entity
    expose :name
    expose :id do |index| index._id.to_s end
    expose :child_groups, with: 'V1::Entities::Indices::Group' do |group|
      group.subgroups.order_by(:position.asc)
    end
  end
end
