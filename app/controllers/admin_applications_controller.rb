class AdminApplicationsController < ApplicationController

  def show
    @application = Application.find(params[:id])
  end

  def approve_or_reject

  end
end