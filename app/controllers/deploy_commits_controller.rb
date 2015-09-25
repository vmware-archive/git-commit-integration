class DeployCommitsController < ApplicationController
  before_action :set_deploy_commit, only: [:show, :edit, :update, :destroy]

  # GET /deploy_commits
  # GET /deploy_commits.json
  def index
    @deploy_commits = DeployCommit.all
  end

  # GET /deploy_commits/1
  # GET /deploy_commits/1.json
  def show
  end

  # GET /deploy_commits/new
  def new
    @deploy_commit = DeployCommit.new
  end

  # GET /deploy_commits/1/edit
  def edit
  end

  # POST /deploy_commits
  # POST /deploy_commits.json
  def create
    @deploy_commit = DeployCommit.new(deploy_commit_params)

    respond_to do |format|
      if @deploy_commit.save
        format.html { redirect_to @deploy_commit, notice: 'Deploy commit was successfully created.' }
        format.json { render :show, status: :created, location: @deploy_commit }
      else
        format.html { render :new }
        format.json { render json: @deploy_commit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deploy_commits/1
  # PATCH/PUT /deploy_commits/1.json
  def update
    respond_to do |format|
      if @deploy_commit.update(deploy_commit_params)
        format.html { redirect_to @deploy_commit, notice: 'Deploy commit was successfully updated.' }
        format.json { render :show, status: :ok, location: @deploy_commit }
      else
        format.html { render :edit }
        format.json { render json: @deploy_commit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deploy_commits/1
  # DELETE /deploy_commits/1.json
  def destroy
    @deploy_commit.destroy
    respond_to do |format|
      format.html { redirect_to deploy_commits_url, notice: 'Deploy commit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deploy_commit
      @deploy_commit = DeployCommit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deploy_commit_params
      params.require(:deploy_commit).permit(:deploy_id, :sha)
    end
end
