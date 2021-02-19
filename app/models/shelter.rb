class Shelter < ApplicationRecord
  has_many :pets

  def self.reverse_all
    all.order(name: :desc)
  end
end
