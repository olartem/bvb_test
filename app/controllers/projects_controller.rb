class ProjectsController < ApplicationController
  def create
    @project = Project.create(project_params)
  end

  def show
    @user = current_user
    @project = Project.find(params[:id])
    @sum = current_donations_sum
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @user, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to root, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def current_donations_sum()
    if @project.donations
      sum = 0
      @project.donations.all.each do |donation|
        sum += donation.amount
      end
      sum
    end
  end

  private

  def project_params
    params.require(:project).permit(:name, :money_goal, :description, :end_date, :images)
  end
end
