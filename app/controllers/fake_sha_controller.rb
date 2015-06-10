class FakeShaController < ApplicationController
  def show
    @params = params
  end
end
