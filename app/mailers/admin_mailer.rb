class AdminMailer < ApplicationMailer
  default to: -> { User.where(is_admin: true).pluck(:email) },
          from: 'olartem03@gmail.com'
  def new_registration
    @user = params[:user]
    mail(subject: "New User Sign Up: #{@user.email}")
  end

  def new_donation
    @donation = params[:donation]
    mail(subject: 'New Donation Waiting For Approve')
  end
end
