require 'rails_helper'

RSpec.describe "Admin Applications Show Page", type: :feature do
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
      zip: 80220,
      description: "I Love Dogs",
      status: "Pending"
    )
    ApplicationPet.create!(application: @trevor, pet: @rico)
    ApplicationPet.create!(application: @trevor, pet: @saki)
  end

  it 'shows the application and its attributes' do
    visit "/admin/applications/#{@trevor.id}"

    expect(page).to have_content(@trevor.name)
    expect(page).to have_content(@trevor.street_address)
    expect(page).to have_content(@trevor.city)
    expect(page).to have_content(@trevor.state)
    expect(page).to have_content(@trevor.zip)
    expect(page).to have_content(@rico.name)
    expect(page).to have_content(@saki.name)
    expect(page).to have_content(@trevor.status)
  end

  it 'Can approve a dog' do
    visit "/admin/applications/#{@trevor.id}"

    expect(page).to have_button("Approve #{@rico.name}")
    expect(page).to have_button("Approve #{@saki.name}")

    click_on "Approve #{@rico.name}"

    expect(page).to_not have_button("Approve #{@rico.name}")
    expect(page).to have_button("Approve #{@saki.name}")
  end
end