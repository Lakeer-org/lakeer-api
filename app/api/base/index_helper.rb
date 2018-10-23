module Base
  module IndexHelper
    extend Grape::API::Helpers
    def create_root_groups(mongo_index, subgroups)
      subgroups.each_with_index do |subgroup, i|
        mongoid_group = mongo_index.groups.create!(name: subgroup['name'], position: i + 1)
        create_subgroups(mongoid_group, subgroup['subgroups'])
      end
    end
    def create_subgroups(mongoid_group, subgroups)
      subgroups.each_with_index do |subgroup, i|
        mongoid_subgroup = mongoid_group.subgroups.create!(name: subgroup['name'], position: i + 1)
        create_subgroups(mongoid_subgroup, subgroup['subgroups'])
      end
    end
  end
end
