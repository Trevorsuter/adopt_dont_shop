class ApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
  end

  def new
    @application = Application.new
  end

  def create
    application = Application.create(app_params)
    redirect_to"/applications/#{application.id}"
  end

  private
  def app_params
    params.permit(:name, :street_address, :city, :state, :zip, :description)
  end
end