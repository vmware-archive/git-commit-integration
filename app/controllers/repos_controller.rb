class ReposController < ApplicationController
  before_action :set_repo, only: [:show, :edit, :update, :destroy, :create_hook]

  # GET /repos
  # GET /repos.json
  def index
    @repos = current_user.repos.all
  end

  # GET /repos/1
  # GET /repos/1.json
  def show
  end

  # GET /repos/new
  def new
    @repo = Repo.new
  end

  # GET /repos/1/edit
  def edit
  end

  # POST /repos
  # POST /repos.json
  def create
    @repo = Repo.new(repo_params)
    @repo.user = current_user

    respond_to do |format|
      if @repo.save
        format.html { redirect_to @repo, notice: 'Repo was successfully created.' }
        format.json { render :show, status: :created, location: @repo }
      else
        format.html { render :new }
        format.json { render json: @repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repos/1
  # PATCH/PUT /repos/1.json
  def update
    respond_to do |format|
      if @repo.update(repo_params)
        format.html { redirect_to @repo, notice: 'Repo was successfully updated.' }
        format.json { render :show, status: :ok, location: @repo }
      else
        format.html { render :edit }
        format.json { render json: @repo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repos/1
  # DELETE /repos/1.json
  def destroy
    @repo.destroy
    respond_to do |format|
      format.html { redirect_to repos_url, notice: 'Repo was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_hook
    @repo.create_hook(request.original_url)
    redirect_to repos_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_repo
    @repo = Repo.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def repo_params
    params.require(:repo).permit(:url, :hook)
  end
end
