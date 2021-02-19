class ApplicationPet < ApplicationRecord
  belongs_to :application
  belongs_to :pet
  validates_presence_of :application
  validates_presence_of :pet

  def self.adopted_pet
  end
end