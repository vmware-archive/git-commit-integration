class GithubUsersController < ApplicationController
  before_action :set_github_user, only: [:show, :edit, :update, :destroy]

  # GET /github_users
  # GET /github_users.json
  def index
    @github_users = GithubUser.all
  end

  # GET /github_users/1
  # GET /github_users/1.json
  def show
  end

  # GET /github_users/new
  def new
    @github_user = GithubUser.new
  end

  # GET /github_users/1/edit
  def edit
  end

  # POST /github_users
  # POST /github_users.json
  def create
    @github_user = GithubUser.new(github_user_params)

    respond_to do |format|
      if @github_user.save
        format.html { redirect_to @github_user, notice: 'Github user was successfully created.' }
        format.json { render :show, status: :created, location: @github_user }
      else
        format.html { render :new }
        format.json { render json: @github_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /github_users/1
  # PATCH/PUT /github_users/1.json
  def update
    respond_to do |format|
      if @github_user.update(github_user_params)
        format.html { redirect_to @github_user, notice: 'Github user was successfully updated.' }
        format.json { render :show, status: :ok, location: @github_user }
      else
        format.html { render :edit }
        format.json { render json: @github_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /github_users/1
  # DELETE /github_users/1.json
  def destroy
    @github_user.destroy
    respond_to do |format|
      format.html { redirect_to github_users_url, notice: 'Github user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_github_user
    @github_user = GithubUser.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def github_user_params
    params.require(:github_user).permit(:username, :email)
  end
end
