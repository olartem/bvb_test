class ProjectsController < ApplicationController
  def show
    @user = current_user
    @project = Project.find(params[:id])
    @markers = project_markers(@project)
    @qrcode = RQRCode::QRCode.new(project_url(@project))
    @svg = @qrcode.as_svg(
      color: "000",
      module_size: 5,
      use_path: true,
    )
    respond_to do |format|
      format.html
      format.png do
        download_qrcode(@project)
      end
    end
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

  def download_qrcode(project)
    send_data RQRCode::QRCode.new(project_url(project)).as_png(size: 300), type: 'image/png', disposition: 'attachment'
  end
end
