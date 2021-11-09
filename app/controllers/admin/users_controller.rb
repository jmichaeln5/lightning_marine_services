module Admin
  class UsersController < Admin::ApplicationController
    before_action :remove_password_params_if_blank, only: [:update]

    # Overwrite any of the RESTful controller actions to implement custom behavior
    # For example, you may want to send an email after a foo is updated.
    #
    # def update
    #   super
    #   send_foo_updated_email(requested_resource)
    # end

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
