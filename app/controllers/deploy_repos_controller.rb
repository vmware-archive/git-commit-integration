class DeployReposController < ApplicationController
  before_action :set_deploy_repo, only: [:show, :edit, :update, :destroy]

  # GET /deploy_repos
  # GET /deploy_repos.json
  def index
    @deploy_repos = DeployRepo.all
  end

  # GET /deploy_repos/1
  # GET /deploy_repos/1.json
  def show
  end

  # GET /deploy_repos/new
  def new
    @deploy_repo = DeployRepo.new
  end

  # GET /deploy_repos/1/edit
  def edit
  end

  # POST /deploy_repos
  # POST /deploy_repos.json
  def create
    @deploy_repo = DeployRepo.new(deploy_repo_params)

    respond_to do |format|
      if @deploy_repo.save
        format.html { redirect_to @deploy_repo, notice: 'Deploy repo was successfully created.' }
        format.json { render :show, status: :created, location: @deploy_repo }
      else
        format.html { render :new }
        format.json { render json: @deploy_repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deploy_repos/1
  # PATCH/PUT /deploy_repos/1.json
  def update
    respond_to do |format|
      if @deploy_repo.update(deploy_repo_params)
        format.html { redirect_to @deploy_repo, notice: 'Deploy repo was successfully updated.' }
        format.json { render :show, status: :ok, location: @deploy_repo }
      else
        format.html { render :edit }
        format.json { render json: @deploy_repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deploy_repos/1
  # DELETE /deploy_repos/1.json
  def destroy
    @deploy_repo.destroy
    respond_to do |format|
      format.html { redirect_to deploy_repos_url, notice: 'Deploy repo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deploy_repo
      @deploy_repo = DeployRepo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deploy_repo_params
      params.require(:deploy_repo).permit(:deploy_id, :repo_id)
    end
end
