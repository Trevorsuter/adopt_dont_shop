require 'rails_helper'

RSpec.describe "Admin Shelters Show page", type: :feature do
  describe 'When I visit an admin shelters show page' do
    before :each do
      @ddfl = Shelter.create!(
      name: "Denver Dumb Friends League",
      address: "123 Doggie Lane",
      city: "Denver",
      state: "CO",
      zip: 80246
      )
    end
    it 'should show that shelters name and address' do
      visit "/admin/shelters/#{@ddfl.id}"

      expect(page).to have_content(@ddfl.name)
      expect(page).to have_content(@ddfl.address)
      expect(page).to have_content(@ddfl.city)
      expect(page).to have_content(@ddfl.state)
      expect(page).to have_content(@ddfl.zip)
    end
  end
end