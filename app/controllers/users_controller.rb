class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_admin
end
