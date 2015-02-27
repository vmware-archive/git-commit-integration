class PushesController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:receive]
  before_action :set_push, only: [:show, :edit, :update, :destroy]

  # GET /pushes
  # GET /pushes.json
  def index
    @pushes = Push.all
  end

  # GET /pushes/1
  # GET /pushes/1.json
  def show
  end

  # GET /pushes/new
  def new
    @push = Push.new
  end

  # GET /pushes/1/edit
  def edit
  end

  # POST /pushes
  # POST /pushes.json
  def create
    @push = Push.new(push_params)

    respond_to do |format|
      if @push.save
        format.html { redirect_to @push, notice: 'Push was successfully created.' }
        format.json { render :show, status: :created, location: @push }
      else
        format.html { render :new }
        format.json { render json: @push.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pushes/1
  # PATCH/PUT /pushes/1.json
  def update
    respond_to do |format|
      if @push.update(push_params)
        format.html { redirect_to @push, notice: 'Push was successfully updated.' }
        format.json { render :show, status: :ok, location: @push }
      else
        format.html { render :edit }
        format.json { render json: @push.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pushes/1
  # DELETE /pushes/1.json
  def destroy
    @push.destroy
    respond_to do |format|
      format.html { redirect_to pushes_url, notice: 'Push was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def receive
    params.permit!
    begin
      @push = Push.from_webhook(params.to_hash)
      @push.save!
    rescue RuntimeError => e
      error_msg = "error when recieving webhook: #{e.inspect}"
      puts error_msg
      render json: {'error_msg' => error_msg} and return
    end

    render text: 'thanks github'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_push
    @push = Push.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def push_params
    params.require(:push).permit(:payload, :ref, :head_commit)
  end
end
