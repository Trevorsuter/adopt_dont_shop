class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.reverse_all
  end

  def show
    @shelter = Shelter.find(params[:id])
  end
end