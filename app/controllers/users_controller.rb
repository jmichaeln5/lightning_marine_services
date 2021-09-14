class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin
  # GET /users or /users.json
  def index
    @users = User.all.order("created_at ASC")
    users = User.all.order("created_at ASC")

    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename=\"user-list\""
        headers['Content-Type'] ||= 'text/csv'
      end
    end


  end

  # GET /users/1 or /users/1.json
  def show
    @user = User.find(params[:id])
    user = @user
  end

end
