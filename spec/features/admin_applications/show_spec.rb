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
    saki = @ddfl.pets.create!(
        name: "Saki",
        approximate_age: 5,
        description: "mutt",
        sex: "female"
      )
    ApplicationPet.create!(application: @trevor, pet: saki)
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

  it "will approve the application after all pets are approved" do
    visit "/admin/applications/#{@trevor.id}"
    click_on("Approve #{@rico.name}")
    expect(page).to_not have_content("Pending")
    expect(page).to have_content("Approved")
  end

  it "will reject the application if one pet is rejected" do
    saki = @ddfl.pets.create!(
      name: "Saki",
      approximate_age: 7,
      description: "dog",
      sex: "female"
    )
    ApplicationPet.create!(application: @trevor, pet: saki)

    visit "/admin/applications/#{@trevor.id}"
    click_on("Approve #{@rico.name}")
    click_on("Reject #{saki.name}")
    expect(page).to_not have_content("Pending")
    expect(page).to have_content("Rejected")
  end

  it "will not affect other app statuses" do
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

    visit "/admin/applications/#{@trevor.id}"
    click_on("Approve #{@rico.name}")
    expect(page).to_not have_content("Pending")
    expect(page).to have_content("Approved")

    visit "/admin/applications/#{maddie.id}"
    expect(page).to have_content("Pending")
  end


  describe "methods" do
    it 'can find the app status by the app id' do
      ddfl = Shelter.create!(
        name: "Denver Dumb Friends League",
        address: "123 Doggie Lane",
        city: "Denver",
        state: "CO",
        zip: 80246
      )
      rico = ddfl.pets.create!(
        name: "Rico",
        approximate_age: 4,
        description: "Staffordshire Terrier",
        sex: "male"
      )
      saki = ddfl.pets.create!(
        name: "Saki",
        approximate_age: 5,
        description: "mutt",
        sex: "female"
      )
      trevor = Application.create!(
        name: "Trevor Suter",
        street_address: "1275 Birch Lane",
        city: "Denver",
        state: "CO",
        zip: 80220
      )
      ApplicationPet.create!(application: trevor, pet: rico, pet_status: "approved")
      ApplicationPet.create!(application: trevor, pet: saki)    

      expect(rico.app_status(trevor.id)).to eq("approved")
      expect(saki.app_status(trevor.id)).to be_nil
    end
  end
end