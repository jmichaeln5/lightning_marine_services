class TableOptionsController < ApplicationController
  before_action :set_table_option, only: %i[ show edit update destroy ]

  # GET /table_options or /table_options.json
  def index
    @table_options = TableOption.all
  end

  # GET /table_options/1 or /table_options/1.json
  def show
  end

  # GET /table_options/new
  def new
    @table_option = TableOption.new
  end

  # GET /table_options/1/edit
  def edit
  end

  # POST /table_options or /table_options.json
  def create
    if @table_option.save
      redirect_to table_option_path(@table_option), notice: "Table Option Created Successfully."
    else
      redirect_to request.referrer
      @table_option.errors.each do |error|
        flash[:alert] = @table_option.errors.full_messages.map {|message| message}
      end
    end
  end

  # PATCH/PUT /table_options/1 or /table_options/1.json
  def update
    if @table_option.update(table_option_params)
      redirect_to request.referrer, notice: "Table options updated successfully. New table options: #{@table_option.option_list}"
    else
      redirect_to request.referrer
      @table_option.errors.each do |error|
        flash[:alert] = @table_option.errors.full_messages.map {|message| message}
      end
    end

  end

  # DELETE /table_options/1 or /table_options/1.json
  def destroy
    @table_option.destroy
    respond_to do |format|
      format.html { redirect_to table_options_url, notice: "Table option was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_table_option
      @table_option = TableOption.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def table_option_params
      # params.require(:table_option).permit(:resource_table_type, :option_list, :user_id)

      params[:table_option][:option_list] ||= []
      params.require(:table_option).permit(:resource_table_type, :user_id, option_list: [])
    end
end
