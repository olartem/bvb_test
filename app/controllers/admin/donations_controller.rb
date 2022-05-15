module Admin
  class DonationsController < Admin::ApplicationController
    prepend AdministrateRansack::Searchable

    def update
      super
      donation = Donation.find(params[:id])
      if donation.confirmation_status && !donation.is_deleted
        project = Project.find(donation.project_id)
        project.current_money += donation.amount
        project.save
      end
    end

    def destroy
      donation = Donation.find(params[:id])
      donation.update_attribute(:is_deleted, true)
      if donation.confirmation_status
        project = Project.find(donation.project_id)
        project.current_money -= donation.amount
        project.save
      end
      redirect_to admin_donations_path
    end

    def export_table
      @donations = Donation.all
      respond_to do |format|
        format.pdf do
          render pdf: 'Donations', template: 'admin/application/donations/export_pdf.html.erb', encoding: 'utf8'
        end
        format.xlsx {
          export_excel
        }
      end
    end
    def export_excel
      Axlsx::Package.new do |excel_package|
        style = excel_package.workbook.styles
        header_cell = style.add_style bg_color: "7FFF00c",:b => true
        article_cell = style.add_style bg_color: "ffffff",:b => true
        delete_cell = style.add_style bg_color: "F08080",:b => true
        excel_package.workbook.add_worksheet(name: "Users") do |sheet|
          sheet.add_image(image_src: Rails.root.join("public", "assets", 'favicon_patrick.png').to_s) do |image|
            image.width = 200
            image.height = 200
            image.start_at 5, 1
          end

          sheet.add_row [Donation.human_attribute_name("user"), Donation.human_attribute_name("project"),
                         Donation.human_attribute_name("amount"), Donation.human_attribute_name("confirmation_status"),
                         Donation.human_attribute_name("is_deleted"), 'Link: ' + root_url], style: header_cell
          sheet.rows[0].cells[5].style = article_cell
          @donations.each do |donation|
            sheet.add_row [donation.user.first_name + ' ' + donation.user.last_name, donation.project.name, donation.amount,
                           donation.confirmation_status, donation.is_deleted],
                          style: donation.confirmation_status ? article_cell : delete_cell
          end
        end
        file = Tempfile.new(['Donations', '.xlsx'])
        excel_package.serialize file
        send_file file
        file.close
      end
    end
    # Override this method to specify custom lookup behavior.
    # This will be used to set the resource for the `show`, `edit`, and `update`
    # actions.
    #
    # def find_resource(param)
    #   Foo.find_by!(slug: param)
    # end

    # The result of this lookup will be available as `requested_resource`

    # Override this if you have certain roles that require a subset
    # this will be used to set the records shown on the `index` action.
    #
    # def scoped_resource
    #   if current_user.super_admin?
    #     resource_class
    #   else
    #     resource_class.with_less_stuff
    #   end
    # end

    # Override `resource_params` if you want to transform the submitted
    # data before it's persisted. For example, the following would turn all
    # empty values into nil values. It uses other APIs such as `resource_class`
    # and `dashboard`:
    #
    # def resource_params
    #   params.require(resource_class.model_name.param_key).
    #     permit(dashboard.permitted_attributes).
    #     transform_values { |value| value == "" ? nil : value }
    # end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
