class ExternalLinkReposController < ApplicationController
  before_action :set_external_link_repo, only: [:show, :edit, :update, :destroy]

  # GET /external_link_repos
  # GET /external_link_repos.json
  def index
    @external_link_repos = ExternalLinkRepo.all
  end

  # GET /external_link_repos/1
  # GET /external_link_repos/1.json
  def show
  end

  # GET /external_link_repos/new
  def new
    @external_link_repo = ExternalLinkRepo.new
  end

  # GET /external_link_repos/1/edit
  def edit
  end

  # POST /external_link_repos
  # POST /external_link_repos.json
  def create
    @external_link_repo = ExternalLinkRepo.new(external_link_repo_params)

    respond_to do |format|
      if @external_link_repo.save
        format.html { redirect_to @external_link_repo, notice: 'External link repo was successfully created.' }
        format.json { render :show, status: :created, location: @external_link_repo }
      else
        format.html { render :new }
        format.json { render json: @external_link_repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /external_link_repos/1
  # PATCH/PUT /external_link_repos/1.json
  def update
    respond_to do |format|
      if @external_link_repo.update(external_link_repo_params)
        format.html { redirect_to @external_link_repo, notice: 'External link repo was successfully updated.' }
        format.json { render :show, status: :ok, location: @external_link_repo }
      else
        format.html { render :edit }
        format.json { render json: @external_link_repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /external_link_repos/1
  # DELETE /external_link_repos/1.json
  def destroy
    @external_link_repo.destroy
    respond_to do |format|
      format.html { redirect_to external_link_repos_url, notice: 'External link repo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_external_link_repo
      @external_link_repo = ExternalLinkRepo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def external_link_repo_params
      params.require(:external_link_repo).permit(:external_link_id, :repo_id)
    end
end
