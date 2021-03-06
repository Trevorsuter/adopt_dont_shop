require 'rails_helper'

describe Shelter, type: :model do
  describe 'relationships' do
    it { should have_many :pets }
  end
  describe 'methods' do
    it 'can find all in reverse alphabetical order' do
      ddfl = Shelter.create!(
      name: "Denver Dumb Friends League",
      address: "123 Doggie Lane",
      city: "Denver",
      state: "CO",
      zip: 80246
      )
      maxfund = Shelter.create!(
        name: "Maxfund",
        address: "456 Kittie Drive",
        city: "Denver",
        state: "CO",
        zip: 80108
      )
      das = Shelter.create!(
        name: "Denver Animal Shelter",
        address: "789 Reptile Court",
        city: "Denver",
        state: "CO",
        zip: 80220
      )

      expect(Shelter.reverse_all).to eq([maxfund, ddfl, das])
      expect(Shelter.reverse_all).to_not eq([das, ddfl, maxfund])
    end
  end
end
