class MigrationController < ApplicationController
  http_basic_authenticate_with :name => "user", :password => "pass"
  before_filter :choose_city, :only => :create
  
  def choose_city
    @domain  = params[:domain][:domain]
    @city    = params[:city].to_sym
    @manager = TaskManager.new(@domain,@city)
    logger.info "\n\nChoosing City #{@city} for Domain #{@domain}\n\n"
    logger.info "\n#{@manager.inspect}\n"
  end
  
  def index
  end

  def create
    @manager.execute
    flash[:notice] = "The migration of #{@domain} was successful."
  rescue
    @manager.rollback
    flash[:alert]  = "The migration of #{@domain} failed."
  end

end
