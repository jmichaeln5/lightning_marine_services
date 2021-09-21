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
    @table_option = TableOption.new(table_option_params)

      # if @table_option.save
      #   format.html { redirect_to @table_option, notice: "Table option was successfully created." }
      #   format.json { render :show, status: :created, location: @table_option }
      # else
      #   format.html { render :new, status: :unprocessable_entity }
      #   format.json { render json: @table_option.errors, status: :unprocessable_entity }
      # end


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
    respond_to do |format|
      if @table_option.update(table_option_params)
        format.html { redirect_to @table_option, notice: "Table option was successfully updated." }
        format.json { render :show, status: :ok, location: @table_option }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @table_option.errors, status: :unprocessable_entity }
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
      params.require(:table_option).permit(:resource_table_type, :option_list, :user_id)
    end
end
