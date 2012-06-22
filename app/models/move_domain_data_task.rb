class MoveDomainDataTask < MigrationTask
  require 'net/ssh'
  
  def initialize(domain,city)
    super    
    prepare_domain_directory
    
    @tasks  = []
    @tasks << ExportSqlTask.new(domain,city)
    @tasks << CopySqlTask.new(domain,city)
    @tasks << ImportSqlTask.new(domain,city)
    @tasks << ActivateSqlTask.new(domain,city)
    @completed_tasks = []
    
    logger "MoveDomainDataTask created for: #{@domain}"
  end
  
  def execute
    @tasks.each do |task|
      @completed_tasks << task
      task.execute
    end
  end
  
  def rollback
    logger "Rolling back MoveDomainDataTask\n"
    @completed_tasks.each {|task| task.rollback }
    remove_domain_directory
  end
  
  def prepare_domain_directory
    Net::SSH.start( *SSH_CREDENTIALS[PRIMARY_CITY][:db] ) do |ssh|
      ssh.exec!( "mkdir /tmp/#{@domain}; chmod 777 /tmp/#{@domain}" )
    end
  end
  
  def remove_domain_directory
    Net::SSH.start( *SSH_CREDENTIALS[PRIMARY_CITY][:db] ) do |ssh|
      ssh.exec!( "rm -rf /tmp/#{@domain}" ) unless @domain.nil? || @domain == '*' || @domain == '.' || @domain == '..'
    end
  end
  
end