class DonationsController < ApplicationController
  before_action :find_project, except: :index
  before_action :authenticate_user!
  before_action :find_donation, only: [:destroy]

  def create
    @donation = current_user.donations.build(donation_params)
    @donation.project = @project
    if @donation.save
      flash[:notice] = 'Donated successfully. Wait for confirmation'
      redirect_to project_path(@project)
    else
      flash[:alert] = 'Select amount'
      redirect_to project_path(@project)
    end
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
