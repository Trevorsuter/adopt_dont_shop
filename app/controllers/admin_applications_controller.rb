class AdminApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
    if params[:button]
      @application.approve_or_reject_pet(params[:pet_id], params[:button])
    end
    @application.change_status
  end
end