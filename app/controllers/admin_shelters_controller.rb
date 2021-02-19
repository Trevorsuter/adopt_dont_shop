class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.reverse_all
  end
end