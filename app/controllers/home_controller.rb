class HomeController < ApplicationController

  def index
    @projects = Project.where(["is_deleted = ? and end_date > ?", "false", DateTime.now]).order(end_date: :desc)
    if params[:sort] == 'all'
      @projects = Project.where(["is_deleted = ?", "false"]).order(end_date: :desc)
    end
    if params[:sort] == 'finished'
      @projects = Project.where(["is_deleted = ? and end_date < ?", "false", DateTime.now]).order(end_date: :desc)
    end
    if params[:search]
      @parameter = params[:search].downcase
      @projects = Project.where("lower(name) LIKE '%#{@parameter}%'").order(end_date: :desc)
    end
  end
end
