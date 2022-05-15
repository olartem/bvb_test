module Admin
  class ProjectsController < Admin::ApplicationController
    prepend AdministrateRansack::Searchable
    
    def destroy_avatar
      image = requested_resource.images.find(params[:attachment_id])
      image.purge
      redirect_back(fallback_location: requested_resource)
    end

    def scoped_resource
      resource_class.with_attached_images
    end

    def destroy
      project = Project.find(params[:id])
      project.update_attribute(:is_deleted, true)
    end

    def export_table
      @projects = Project.all
      respond_to do |format|
        format.pdf do
          render pdf: 'Projects', template: 'admin/application/projects/export_pdf.html.erb', encoding: 'utf8'
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

          sheet.add_row [Project.human_attribute_name("name"), Project.human_attribute_name("money_goal"),
                         Project.human_attribute_name("current_money"), Project.human_attribute_name("end_date"),
                         Project.human_attribute_name("is_deleted"), 'Link: ' + root_url], style: header_cell
          sheet.rows[0].cells[5].style = article_cell
          @projects.each do |project|
            sheet.add_row [project.name, project.money_goal, project.current_money, project.end_date.strftime("%F"),
                           project.is_deleted], style: project.end_date > DateTime.now ? article_cell : delete_cell
          end
        end
        file = Tempfile.new(['Projects', '.xlsx'])
        excel_package.serialize file
        send_file file
        file.close
      end
    end
    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.
    #
    # def update
    #   super
    #   send_foo_updated_email(requested_resource)
    # end

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
