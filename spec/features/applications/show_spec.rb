require 'rails_helper'

RSpec.describe "Applications Show page", type: :feature do

  describe "When I visit an application's show page" do
    before :each do
      @ddfl = Shelter.create!(
        name: "Denver Dumb Friends League",
        address: "123 Doggie Lane",
        city: "Denver",
        state: "CO",
        zip: 80246
      )
      @rico = @ddfl.pets.create!(
        name: "Rico",
        approximate_age: 4,
        description: "Staffordshire Terrier",
        sex: "male"
      )
      @saki = @ddfl.pets.create!(
        name: "Saki",
        approximate_age: 5,
        description: "mutt",
        sex: "female"
      )
      @trevor = Application.create!(
        name: "Trevor Suter",
        street_address: "1275 Birch Lane",
        city: "Denver",
        state: "CO",
        zip: 80220
      )
      @maddie = Application.create!(
        name: "Maddie Suter",
        street_address: "12 Birch Lane",
        city: "Denver",
        state: "CO",
        zip: 80246
      )
    end
    it "can see all of it's attributes" do
      ApplicationPet.create!(application: @trevor, pet: @rico)
      ApplicationPet.create!(application: @trevor, pet: @saki)
      ApplicationPet.create!(application: @maddie, pet: @saki)

      visit "/applications/#{@trevor.id}"

      expect(page).to have_content(@trevor.name)
      expect(page).to have_content(@trevor.street_address)
      expect(page).to have_content(@trevor.city)
      expect(page).to have_content(@trevor.state)
      expect(page).to have_content(@trevor.zip)
      expect(page).to have_content(@rico.name)
      expect(page).to have_content(@saki.name)
      expect(page).to have_content(@trevor.status)

      visit "/applications/#{@maddie.id}"

      expect(page).to have_content(@maddie.name)
      expect(page).to have_content(@maddie.street_address)
      expect(page).to have_content(@maddie.city)
      expect(page).to have_content(@maddie.state)
      expect(page).to have_content(@maddie.zip)
      expect(page).to have_content(@saki.name)
      expect(page).to have_content(@maddie.status)
    end

    it 'has links to the pets on the application' do
      ApplicationPet.create!(application: @trevor, pet: @rico)
      ApplicationPet.create!(application: @trevor, pet: @saki)

      visit "/applications/#{@trevor.id}"

      expect(page).to have_link("#{@rico.name}", href: "/pets/#{@rico.id}")
      expect(page).to have_link("#{@saki.name}", href: "/pets/#{@saki.id}")

    end
    it 'has a field to search for adoptable pets' do
      visit "/applications/#{@trevor.id}"

      fill_in "Search pets", with: "Rico"
      click_on("search")

      expect(page).to have_content(@rico.name)
    end

    it 'can add a pet to the application' do
      visit "/applications/#{@trevor.id}"

      fill_in "Search pets", with: "Rico"
      click_on("search")
      click_on("Adopt This Pet")

      expect(@trevor.pets).to include(@rico)
      expect(page).to have_link("#{@rico.name}", href: "/pets/#{@rico.id}")
    end

    it 'can submit an application' do
      visit "/applications/#{@trevor.id}"

      fill_in "Search pets", with: "Rico"
      click_on("search")
      click_on("Adopt This Pet")

      visit "/applications/#{@trevor.id}"

      fill_in "description", with: "I love Dogs"
      click_on("submit")

      expect(page).to_not have_selector("submit")
      expect(page).to have_content(@trevor.name)
      expect(page).to have_content("Pending")
      expect(page).to_not have_content("In Progress")
    end

    it 'can find partial pet name matches' do
      ricoboy = @ddfl.pets.create!(
        name: "Ricoboy",
        approximate_age: 4,
        description: "Staffordshire Terrier",
        sex: "male"
      )
      visit "/applications/#{@trevor.id}"

      fill_in "Search pets", with: "Rico"
      click_on("search")

      expect(page).to have_content(@rico.name)
      expect(page).to have_content(ricoboy.name)
    end

    it 'can find a pet without being case sensitive' do
      ricoboy = @ddfl.pets.create!(
        name: "Ricoboy",
        approximate_age: 4,
        description: "Staffordshire Terrier",
        sex: "male"
      )
      visit "/applications/#{@trevor.id}"

      fill_in "Search pets", with: "RiCo"
      click_on("search")

      expect(page).to have_content(@rico.name)
      expect(page).to have_content(ricoboy.name)
    end
  end
end