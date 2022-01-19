class ProjectsController < ApplicationController
  def show
    @user = current_user
    @project = Project.find(params[:id])
    @markers = project_markers(@project)
  end

  def project_markers(project)
    markers = []
    project.donations.each do |donation|
      if donation.confirmation_status
        user = User.find(donation.user_id)
        if user.location
          marker = [user.first_name + ' ' + user.last_name, user.location.latitude,
                    user.location.longitude]
          markers.push(marker)
        end
      end
    end
    markers
  end
end
