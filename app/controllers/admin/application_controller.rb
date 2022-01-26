# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    before_action :authenticate_admin
    before_action :set_locale

    def authenticate_admin
      authenticate_user!
      redirect_to home_index_path, alert: 'You are not an admin' unless current_user.is_admin?
    end

    private

    def default_url_options
      { locale: I18n.locale }
    end

    def set_locale
      I18n.locale = extract_locale || I18n.default_locale
    end
  
    def extract_locale
      parsed_locale = params[:locale]
      I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
    end
    

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
