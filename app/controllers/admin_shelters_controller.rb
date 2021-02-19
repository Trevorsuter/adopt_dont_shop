class AdminSheltersController < ApplicationController
  def index
    @shelters = Shelter.reverse_all
    @pending = Shelter.pending
  end

  def show
    @shelter = Shelter.find(params[:id])
  end
end