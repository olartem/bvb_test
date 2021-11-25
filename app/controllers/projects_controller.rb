class ProjectsController < ApplicationController

  def show
    @user = current_user
    @project = Project.find(params[:id])
  end

end
