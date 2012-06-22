class MigrationTask
  
  def initialize(domain,city)
    @domain = domain
    @city   = city
    logger "Set @domain = #{@domain} for domain = #{domain}\n"
  end
  
  def execute
    nil
  end
  
  def rollback
    nil
  end
  
  def logger(statement)
    ActionController::Base.logger.info statement
  end
  
end