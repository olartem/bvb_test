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
          render xlsx: 'Projects', template: 'admin/application/projects/export_excel.xlsx.axlsx'
        }
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
