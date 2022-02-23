### TODO  AdminHelpersUsers are NOT being used, time crunch, MUST REFACTOR
### TODO  AdminHelpersUsers are NOT being used, time crunch, MUST REFACTOR
### TODO  AdminHelpersUsers are NOT being used, time crunch, MUST REFACTOR

# autoload :AdminHelpersUsers, "admin_helpers/admin_helpers_users/admin_helpers_users.rb"

module Admin
  # extend AdminHelpersUsers
  class UsersController < Admin::ApplicationController
    # extend AdminHelpersUsers

    before_action :remove_password_params_if_blank, only: [:update]
    before_action :set_user, only: [:show, :edit, :update, :destroy]

    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.

    # def update
    #   super
    #   send_foo_updated_email(requested_resource)
    # end

    def new
      # AdminHelpers.get_admin_helpers_users
      # AdminHelpersUsers.admin_helpers_users_yeet_self
      # AdminHelpersUsers.get_admin_helpers_users_new
      # AdminUsersHelpersNew.admin_users_helpers_new_yeet_self
      super
    end

    def resolve_email_confirmation( options = {})
      return true if params[:user][:bypass_email_confirmation] == 'true'
      return false
    end

    def delete_user_bypass_email_confirmation_params( options = {})
      params[:user].delete(:bypass_email_confirmation)
    end

    def show
      super
    end


    def create
      continue_skip_user_email_confirmation = resolve_email_confirmation( params ) ? true : false
      @skip_user_email_confirmation = continue_skip_user_email_confirmation
      delete_user_bypass_email_confirmation_params( params )

      resource = resource_class.new(resource_params)
      authorize_resource(resource)

      if @skip_user_email_confirmation == true and resource.save
        resource.update(confirmed_at: Time.now.utc)
        authorize_resource(resource)

        redirect_to(
          admin_user_path(resource.id),
          notice: translate_with_resource("create.success")
        )
      else
        super
      end
    end

    def update
      continue_skip_user_email_confirmation = resolve_email_confirmation( params ) ? true : false
      @skip_user_email_confirmation = continue_skip_user_email_confirmation
      delete_user_bypass_email_confirmation_params( params )

      resource_before_update = User.find(params[:id])

      if @skip_user_email_confirmation == true and (resource_before_update.update(resource_params))
        update_resource = resource_before_update.update(confirmed_at: Time.now.utc)
        authorize_resource(update_resource)
        super
      else
        super
      end
    end


    def remove_password_params_if_blank
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
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

    private

    def set_user
      @user = User.find(params[:id])
    end

    def target_resource_params
      self.dashboard.permitted_attributes
    end

    def generic_role_ids_arr
      generic_role_ids_arr = Array.new
      Role.generic_roles.map {|r| generic_role_ids_arr << r.id.to_s}
      return generic_role_ids_arr
    end

    def params_role_ids_arr
      if params[:role_ids].present?
        params[:role_ids].reject!(&:empty?)
        generic_role_ids_arr
        params_role_ids_arr = Array.new

        params[:role_ids].each do |role_id|
          valid_role_id = (
              ((role_id.to_i.is_a? Numeric) and (role_id.to_i > 0 )) ?
              true : false
          )
          params_role_ids_arr << role_id if valid_role_id
        end
        params_role_ids_arr
      end
    end

    def sanatized_params_role_ids_arr
      generic_role_ids_arr
      params_role_ids_arr
      if params_role_ids_arr.present? and generic_role_ids_arr.present?
        sanatized_params_role_ids_arr = Array.new
        params_role_ids_arr.each do |role_id|
          sanatized_params_role_ids_arr << role_id if generic_role_ids_arr.include? role_id
        end
      end
      sanatized_params_role_ids_arr
    end

    def merge_sanitized_user_roles( options = {} )
      params = options
      sanatized_params_role_ids_arr

      if sanatized_params_role_ids_arr.present?
        params[:user][:role_ids] = sanatized_params_role_ids_arr
      end
    end

    def resource_params
      if (controller_name == 'users') and (
        action_name == 'create' or action_name == 'update'
      )
        merge_sanitized_user_roles(params)
      end

      sanatized_params = params.require(resource_class.model_name.param_key).
        permit(dashboard.permitted_attributes).
        transform_values { |value| value == "" ? nil : value }
    end

    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
