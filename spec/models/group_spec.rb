require 'rails_helper'

RSpec.describe Group, type: :model do
  let!(:user) { User.create!(email: 'test@commutatus.com', password: 'password123') }
  let!(:index) { user.indices.create(name: 'Index 1') }
  context 'with simple' do
    it 'creates groups at the last position' do
      group1 = index.child_groups.create!(name: 'Group 1')
      group2 = index.child_groups.create!(name: 'Group 2')
      expect(group1.position).to eq 1
      expect(group2.position).to eq 2
    end
    it 'creates child_groups at the last position' do
      group1 = index.child_groups.create!(name: 'Group 1')
      group2 = group1.child_groups.create!(name: 'Group 2')
      group3 = group1.child_groups.create!(name: 'Group 2')
      expect(group1.reload.position).to eq 1
      expect(group2.position).to eq 1
      expect(group3.position).to eq 2
    end
    it 'handles positions correctly when moving groups' do
      group1 = index.child_groups.create!(name: 'Group 1')
      group2 = index.child_groups.create!(name: 'Group 2')
      group3 = group1.child_groups.create!(name: 'Group 3')
      group4 = group1.child_groups.create!(name: 'Group 4')
      group5 = group1.child_groups.create!(name: 'Group 5')
      group6 = group2.child_groups.create!(name: 'Group 6')
      group7 = group2.child_groups.create!(name: 'Group 7')
      group8 = group2.child_groups.create!(name: 'Group 8')
      expect(group4.reload.position).to eq 2
      group4.move(group2, 2)
      expect(group4.reload.position).to eq 2
      expect(group6.reload.position).to eq 1
      expect(group7.reload.position).to eq 3
      expect(group8.reload.position).to eq 4
      expect(group3.reload.position).to eq 1
      expect(group5.reload.position).to eq 2
      expect(group2.reload.child_groups).to include group4
    end
    it 'checks groups and child_groups correctly' do
      group1 = index.child_groups.create!(name: 'Group 1')
      group2 = index.child_groups.create!(name: 'Group 2')
      group3 = group1.child_groups.create!(name: 'Group 3')
      group4 = group1.child_groups.create!(name: 'Group 4')
      group5 = group1.child_groups.create!(name: 'Group 5')
      group6 = group2.child_groups.create!(name: 'Group 6')
      group7 = group2.child_groups.create!(name: 'Group 7')
      group8 = group2.child_groups.create!(name: 'Group 8')
      expect(group1.reload.is_checked).to be true
      group1.check
      expect(group1.reload.is_checked).to be false
      expect(group3.reload.is_checked).to be false
      group3.check
      expect(group3.reload.is_checked).to be true
      expect(group1.reload.is_checked).to be false
    end
    it 'decreases sister indexes when deleting an item' do
      group1 = index.child_groups.create!(name: 'Group 1')
      group2 = index.child_groups.create!(name: 'Group 2')
      group3 = group1.child_groups.create!(name: 'Group 3')
      group4 = group1.child_groups.create!(name: 'Group 4')
      group5 = group1.child_groups.create!(name: 'Group 5')
      group6 = group2.child_groups.create!(name: 'Group 6')
      group7 = group2.child_groups.create!(name: 'Group 7')
      group8 = group2.child_groups.create!(name: 'Group 8')
      group1.destroy
      expect(group2.reload.position).to eq 1
      expect { group1.reload }.to raise_error(Mongoid::Errors::DocumentNotFound)
      expect { group3.reload }.to raise_error(Mongoid::Errors::DocumentNotFound)

    end
  end
end
