class AdminApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
    approve_or_reject if params[:button]
  end

  def approve_or_reject
    @app_pet = ApplicationPet.where(application: params[:id], pet: params[:pet_id]).first
    @app_pet.assign_attributes(pet_status: params[:button])
    @app_pet.save
  end
end