class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet
  validates_presence_of :application
  validates_presence_of :pet

  # def self.pet_status(app_id, pet_id)
  #   where(application: app_id, pet: pet_id).first.pet_status
  # end
end