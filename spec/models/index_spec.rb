require 'rails_helper'

RSpec.describe Index, type: :model do
  context "no indexes" do
    let!(:user) { User.create!(email: 'test@commutatus.com', password: 'password123') }
    let!(:index) { user.indices.create(name: "Index 1") }
    it "creates an index correctly" do
      expect(user.indices.count).to eq 1
      expect(index.owner).to eq user
    end
    it "deletes an index" do
      user.indices.delete(index)
      expect {index.reload}.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
    it "deletes an index when its user is deleted" do
      user.destroy
      expect {index.reload}.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
  end
end
