class DonationsController < ApplicationController
  before_action :find_project
  before_action :find_donation, only: [:destroy]
  def create
    @donation = current_user.donations.build(donation_params)
    @donation.project = @project
    if @donation.save
      flash[:notice] = "Donated successfully" 
      redirect_to root_path
    else 
      flash[:alert] = "Something went wrong"
    end
  end

  def destroy
    @donation.is_deleted = true
  end

  private
  
  def donation_params
    params.require(:donation).permit(:amount)
  end

  def find_project
    @project = Project.find(params[:project_id])
  end

  def find_donation
    @donation = @project.donations.find(params[:id])
  end
end
