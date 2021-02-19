class Application < ApplicationRecord
  has_many :application_pets
  has_many :pets, through: :application_pets
  validates_presence_of(:name, :street_address, :city, :state, :zip, :status)
  


  def pets
    pet_ids.map do |id|
      Pet.find(id)
    end
  end

  def approve_or_reject_pet(pet_id, value)
    app_pet = ApplicationPet.where(application: self.id, pet: pet_id).first
    app_pet.update_attribute(:pet_status, value)
    app_pet.save
  end

  def pet_statuses
    app = Application.select('application_pets.pet_status, applications.*').joins(:application_pets).where(id: self.id)
    app.map do |a|
      a.pet_status
    end
  end

  def change_status
    if !pet_statuses.include?(nil) && pet_statuses.include?("rejected")
      self.update_attribute(:status, "Rejected")
    elsif !pet_statuses.include?(nil) && !pet_statuses.include?("rejected")
      self.update_attribute(:status, "Approved")
    else
      self.update_attribute(:status, "Pending")
    end
  end
end