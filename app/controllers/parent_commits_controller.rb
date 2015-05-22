class ParentCommitsController < ApplicationController
  before_action :set_commit
  before_action :set_parent_commit, only: [:show, :update, :destroy]

  # GET /parent_commits
  # GET /parent_commits.json
  def index
    @parent_commits = @commit.parent_commits.all
  end

  # GET /parent_commits/1
  # GET /parent_commits/1.json
  def show
  end

  # POST /parent_commits
  # POST /parent_commits.json
  def create
    @parent_commit = ParentCommit.new(parent_commit_params)

    respond_to do |format|
      if @parent_commit.save
        format.html { redirect_to @parent_commit, notice: 'Parent commit was successfully created.' }
        format.json { render :show, status: :created, location: @parent_commit }
      else
        format.html { render :new }
        format.json { render json: @parent_commit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /parent_commits/1
  # PATCH/PUT /parent_commits/1.json
  def update
    respond_to do |format|
      if @parent_commit.update(parent_commit_params)
        format.html { redirect_to @parent_commit, notice: 'Parent commit was successfully updated.' }
        format.json { render :show, status: :ok, location: @parent_commit }
      else
        format.html { render :edit }
        format.json { render json: @parent_commit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /parent_commits/1
  # DELETE /parent_commits/1.json
  def destroy
    @parent_commit.destroy
    respond_to do |format|
      format.html { redirect_to commit_parent_commits_url(@commit), notice: 'Parent commit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_parent_commit
    @parent_commit = @commit.parent_commits.find(params[:id])
  end

  def set_commit
    @commit = Commit.find(params[:commit_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def parent_commit_params
    params.require(:parent_commit).permit(:commit_id, :sha)
  end
end
