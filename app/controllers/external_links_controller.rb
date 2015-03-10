class ExternalLinksController < ApplicationController
  before_action :set_external_link, only: [:show, :edit, :update, :destroy]

  # GET /external_links
  # GET /external_links.json
  def index
    @external_links = ExternalLink.all
  end

  # GET /external_links/1
  # GET /external_links/1.json
  def show
  end

  # GET /external_links/new
  def new
    @external_link = ExternalLink.new
  end

  # GET /external_links/1/edit
  def edit
  end

  # POST /external_links
  # POST /external_links.json
  def create
    @external_link = ExternalLink.new(external_link_params)

    respond_to do |format|
      if @external_link.save
        format.html { redirect_to @external_link, notice: 'External link was successfully created.' }
        format.json { render :show, status: :created, location: @external_link }
      else
        format.html { render :new }
        format.json { render json: @external_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /external_links/1
  # PATCH/PUT /external_links/1.json
  def update
    respond_to do |format|
      if @external_link.update(external_link_params)
        format.html { redirect_to @external_link, notice: 'External link was successfully updated.' }
        format.json { render :show, status: :ok, location: @external_link }
      else
        format.html { render :edit }
        format.json { render json: @external_link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /external_links/1
  # DELETE /external_links/1.json
  def destroy
    @external_link.destroy
    respond_to do |format|
      format.html { redirect_to external_links_url, notice: 'External link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_external_link
      @external_link = ExternalLink.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def external_link_params
      params.require(:external_link).permit(:description, :extract_pattern, :uri_template, :replace_pattern)
    end
end
