class Shelter < ApplicationRecord
  has_many :pets

  def self.reverse_all
    all.order(name: :desc)
  end

  def self.pending
    pets = Application.pending_pets
    pets.map do |p|
      find(p.shelter_id)
    end.uniq
  end
end
