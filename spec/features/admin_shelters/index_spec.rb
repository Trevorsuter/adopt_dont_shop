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
      @rico = @ddfl.pets.create!(
        name: "Rico",
        approximate_age: 4,
        description: "Staffordshire Terrier",
        sex: "male"
      )
      @trevor = Application.create!(
        name: "Trevor Suter",
        street_address: "1275 Birch Lane",
        city: "Denver",
        state: "CO",
        zip: 80220,
        description: "I Love Dogs",
        status: "Pending"
      )

    ApplicationPet.create!(application: @trevor, pet: @rico)
    end
    it 'should list all the shelters' do
      visit "/admin/shelters"

      expect(page).to have_content(@ddfl.name)
      expect(page).to have_content(@maxfund.name)
      expect(page).to have_content(@das.name)
    end

    it 'should have a section listing all shelters with pending applications' do
      visit "/admin/shelters"

      within('.pending') do
        expect(page).to have_content(@ddfl.name)
      end
    end
  end
end