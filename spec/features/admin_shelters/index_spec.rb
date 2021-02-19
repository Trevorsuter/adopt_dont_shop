require 'rails_helper'

RSpec.describe "Admin Shelters index page", type: :feature do
  describe 'when I visit the admin shelters page' do
    before :each do
      @ddfl = Shelter.create!(
      name: "Denver Dumb Friends League",
      address: "123 Doggie Lane",
      city: "Denver",
      state: "CO",
      zip: 80246
      )
      @maxfund = Shelter.create!(
        name: "Maxfund",
        address: "456 Kittie Drive",
        city: "Denver",
        state: "CO",
        zip: 80108
      )
      @das = Shelter.create!(
        name: "Denver Animal Shelter",
        address: "789 Reptile Court",
        city: "Denver",
        state: "CO",
        zip: 80220
      )
    end
    it 'should list all the shelters' do
      visit "/admin/shelters"

      expect(page).to have_content(@ddfl.name)
      expect(page).to have_content(@maxfund.name)
      expect(page).to have_content(@das.name)
    end
  end
end