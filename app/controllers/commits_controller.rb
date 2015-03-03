class CommitsController < ApplicationController
  before_action :set_commit, only: [:show, :edit, :update, :destroy]
  before_action :set_repo
  before_action :set_push, only: [:index, :new, :create]

  # GET /commits
  # GET /commits.json
  def index
p '--------------- here'
    @commits = @push ? Commit.where(push_id: @push.id) : Commit.joins(:push).where('pushes.repo_id' => @repo.id)
  end

  # GET /commits/1
  # GET /commits/1.json
  def show
  end

  # GET /commits/new
  def new
    @commit = @push.commits.build
  end

  # GET /commits/1/edit
  def edit
  end

  # POST /commits
  # POST /commits.json
  def create
    @commit = @push.commits.build(commit_params)

    respond_to do |format|
      if @commit.save
        format.html { redirect_to @commit, notice: 'Commit was successfully created.' }
        format.json { render :show, status: :created, location: @commit }
      else
        format.html { render :new }
        format.json { render json: @commit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commits/1
  # PATCH/PUT /commits/1.json
  def update
    respond_to do |format|
      if @commit.update(commit_params)
        format.html { redirect_to @commit, notice: 'Commit was successfully updated.' }
        format.json { render :show, status: :ok, location: @commit }
      else
        format.html { render :edit }
        format.json { render json: @commit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commits/1
  # DELETE /commits/1.json
  def destroy
    @commit.destroy
    respond_to do |format|
      format.html { redirect_to repo_commits_url(@repo), notice: 'Commit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commit
      @commit = Commit.find(params[:id])
    end

    def set_repo
      @repo = Repo.find(params[:repo_id] || @commit.repo.id)
    end

    def set_push
      @push = Push.find(params[:push_id]) if params[:push_id]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def commit_params
      params.require(:commit).permit(:data, :sha, :patch_id, :message, :author_github_user_id, :author_date, :committer_github_user_id, :committer_date, :push_id)
    end
end
