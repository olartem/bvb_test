module Admin
  class UsersController < Admin::ApplicationController
    prepend AdministrateRansack::Searchable

    def destroy_avatar
      avatar = requested_resource.avatar
      avatar.purge
      redirect_back(fallback_location: requested_resource)
    end

    def scoped_resource
      resource_class.with_attached_avatar
    end

    def destroy
      user = User.find(params[:id])
      user.update_attribute(:is_deleted, true)
    end

    def export_table
      @users = User.all
      respond_to do |format|
        format.pdf do
          render pdf: 'Users', template: 'admin/application/users/export_pdf.html.erb', encoding: 'utf8'
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
            image.start_at 6, 1
          end

          sheet.add_row [User.human_attribute_name("first_name"), User.human_attribute_name("last_name"),
                         User.human_attribute_name("birth_date"), User.human_attribute_name("city"),
                         User.human_attribute_name("is_admin"), User.human_attribute_name("is_deleted"),
                         'Link: ' + root_url], style: header_cell
          sheet.rows[0].cells[6].style = article_cell
          @users.each do |user|
            sheet.add_row [user.first_name, user.last_name, user.birth_date, user.city, user.is_admin,
                           user.is_deleted], style: user.is_deleted ? delete_cell : article_cell
          end
        end
        file = Tempfile.new(['Users', '.xlsx'])
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
