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

  it 'shows the application and its attributes' do
    visit "/admin/applications/#{@trevor.id}"

    expect(page).to have_content(@trevor.name)
    expect(page).to have_content(@trevor.street_address)
    expect(page).to have_content(@trevor.city)
    expect(page).to have_content(@trevor.state)
    expect(page).to have_content(@trevor.zip)
    expect(page).to have_content(@rico.name)
    expect(page).to have_content(@trevor.status)
  end

  it 'Can approve a dog' do
    visit "/admin/applications/#{@trevor.id}"

    expect(page).to have_button("Approve #{@rico.name}")
    expect(page).to have_button("Reject #{@rico.name}")
    expect(page).to_not have_content("approved")
    expect(page).to_not have_content("rejected")

    click_on("Approve #{@rico.name}")
    
    expect(page).to_not have_button("Approve #{@rico.name}")
    expect(page).to_not have_button("Reject #{@rico.name}")
    expect(page).to have_content("approved")
  end

  it 'Can approve a dog' do
    visit "/admin/applications/#{@trevor.id}"

    expect(page).to have_button("Approve #{@rico.name}")
    expect(page).to have_button("Reject #{@rico.name}")
    expect(page).to_not have_content("approved")
    expect(page).to_not have_content("rejected")

    click_on("Reject #{@rico.name}")
    
    expect(page).to_not have_button("Approve #{@rico.name}")
    expect(page).to_not have_button("Reject #{@rico.name}")
    expect(page).to have_content("rejected")
  end

  it "wont affect other applications when a pet is approved or rejected" do
    maddie = Application.create!(
      name: "Maddie Suter",
      street_address: "1200 Larimer St",
      city: "Denver",
      state: "CO",
      zip: 80220,
      description: "I Love All Dogs",
      status: "Pending"
    )
    ApplicationPet.create!(application: maddie, pet: @rico)

    # Visit's Trevor's admin application page
    visit "/admin/applications/#{@trevor.id}"
    click_on("Approve #{@rico.name}")
    expect(page).to_not have_button("Approve #{@rico.name}")
    expect(page).to_not have_button("Reject #{@rico.name}")

    #visit Maddie's admin applications page
    visit "/admin/applications/#{maddie.id}"
    expect(page).to have_button("Approve #{@rico.name}")
    expect(page).to have_button("Reject #{@rico.name}")
  end
end