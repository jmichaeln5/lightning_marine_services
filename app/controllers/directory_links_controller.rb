class DirectoryLinksController < ApplicationController
  before_action :authenticate_admin
  before_action :set_directory_link, only: %i[ show edit update destroy ]

  # GET /directory_links or /directory_links.json
  def index
    @directory_links = DirectoryLink.all
    @new_directory_link = DirectoryLink.new
  end

  # GET /directory_links/1 or /directory_links/1.json
  def show
    @new_directory_link = DirectoryLink.new
  end

  # GET /directory_links/new
  def new
    @directory_link = DirectoryLink.new
  end

  # GET /directory_links/1/edit
  def edit
  end

  # POST /directory_links or /directory_links.json
  def create
    @directory_link = DirectoryLink.new directory_link_params
    @directory_link.id = DirectoryLink.last.id + 1
    if @directory_link.save
      redirect_to directory_link_path(@directory_link), notice: "Directory Link Created Successfully."
    else
      redirect_to request.referrer
      @directory_link.errors.each do |error|
        flash[:alert] = @directory_link.errors.full_messages.map {|message| message}
      end
    end
  end
  # PATCH/PUT /directory_links/1 or /directory_links/1.json
  # def update
  #   respond_to do |format|
  #     if @directory_link.update(directory_link_params)
  #       format.html { redirect_to @directory_link, notice: "Directory Link was successfully updated." }
  #       format.json { render :show, status: :ok, location: @directory_link }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @directory_link.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end


  def update
    @directory_link = DirectoryLink.find(params[:id])
    if @directory_link.update(directory_link_params)
      redirect_to request.referrer, notice: "Directory Link Updated Successfully."
    else
      redirect_to request.referrer
      @directory_link.errors.each do |error|
        flash[:alert] = @directory_link.errors.full_messages.map {|message| message}
      end
    end
  end

  # DELETE /directory_links/1 or /directory_links/1.json
  def destroy
    @directory_link.destroy
    respond_to do |format|
      format.html { redirect_to directory_links_url, notice: "Directory link was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_directory_link
      @directory_link = DirectoryLink.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def directory_link_params
      params.require(:directory_link).permit(:title, :link, :desc, :info)
    end
end
