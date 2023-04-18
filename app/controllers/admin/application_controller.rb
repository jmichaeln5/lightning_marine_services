# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    include SetCurrentRequestDetails
    include Authentication
    include Authorization

    before_action :authenticate_user!
    before_action :authorize_admin

    # def authorize_admin
    #   redirect_to root_path, alert: 'Not authorized.' unless current_user.has_role?(:admin)
    # end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end



    # ### create method from docs:
    # ### https://github.com/thoughtbot/administrate/blob/main/app/controllers/administrate/application_controller.rb
    # def create
    #   resource = resource_class.new(resource_params)
    #   authorize_resource(resource)
    #
    #   if resource.save
    #     redirect_to(
    #       after_resource_created_path(resource),
    #       notice: translate_with_resource("create.success"),
    #     )
    #   else
    #     render :new, locals: {
    #       page: Administrate::Page::Form.new(dashboard, resource),
    #     }, status: :unprocessable_entity
    #   end
    # end


  end
end
