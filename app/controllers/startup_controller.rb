class StartupController < ApplicationController
  def create
 
    Startup.rake_create(params[:startup_id],params[:id],params[:name],params[:email])
  end
end
