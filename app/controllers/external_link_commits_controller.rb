class ExternalLinkCommitsController < ApplicationController
  before_action :set_external_link_commit, only: [:show, :edit, :update, :destroy]

  # GET /external_link_commits
  # GET /external_link_commits.json
  def index
    @external_link_commits = ExternalLinkCommit.all
  end

  # GET /external_link_commits/1
  # GET /external_link_commits/1.json
  def show
  end

  # GET /external_link_commits/new
  def new
    @external_link_commit = ExternalLinkCommit.new
  end

  # GET /external_link_commits/1/edit
  def edit
  end

  # POST /external_link_commits
  # POST /external_link_commits.json
  def create
    @external_link_commit = ExternalLinkCommit.new(external_link_commit_params)

    respond_to do |format|
      if @external_link_commit.save
        format.html { redirect_to @external_link_commit, notice: 'External link commit was successfully created.' }
        format.json { render :show, status: :created, location: @external_link_commit }
      else
        format.html { render :new }
        format.json { render json: @external_link_commit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /external_link_commits/1
  # PATCH/PUT /external_link_commits/1.json
  def update
    respond_to do |format|
      if @external_link_commit.update(external_link_commit_params)
        format.html { redirect_to @external_link_commit, notice: 'External link commit was successfully updated.' }
        format.json { render :show, status: :ok, location: @external_link_commit }
      else
        format.html { render :edit }
        format.json { render json: @external_link_commit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /external_link_commits/1
  # DELETE /external_link_commits/1.json
  def destroy
    @external_link_commit.destroy
    respond_to do |format|
      format.html { redirect_to elcs_url, notice: 'External link commit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_external_link_commit
      @external_link_commit = ExternalLinkCommit.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def external_link_commit_params
      params.require(:external_link_commit).permit(:external_link_id, :commit_id)
    end
end
