class UsersController < ApplicationController
  before_action :authenticate_user!
  def donations
    @user = User.find(params[:user_id])
  end
end