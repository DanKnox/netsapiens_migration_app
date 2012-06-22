class MoveDidDataTask < MigrationTask
  require 'net/ssh'
  
  def initialize(domain,city)
    super    
    prepare_did_data_directory
    
    @tasks  = []
    @tasks << ExportDidSqlTask.new(domain,city)
    @tasks << CopyDidSqlTask.new(domain,city)
    @tasks << ImportDidSqlTask.new(domain,city)
    @tasks << ActivateDidSqlTask.new(domain,city)
    @completed_tasks = []
    
    logger "MoveDomainDataTask created for: #{@domain}"
  end
  
  def execute
    @tasks.each do |task|
      @completed_tasks << task
      task.execute
    end
    remove_did_data_directory
  end
  
  def rollback
    logger "Rolling back MoveDomainDataTask\n"
    @completed_tasks.each {|task| task.rollback }
    remove_did_data_directory
  end
  
  def prepare_did_data_directory
    Net::SSH.start( *SSH_CREDENTIALS[PRIMARY_CITY][:db] ) do |ssh|
      ssh.exec!( "mkdir /tmp/#{@domain}-did; chmod 777 /tmp/#{@domain}-did" )
    end
  end
  
  def remove_did_data_directory
    Net::SSH.start( *SSH_CREDENTIALS[PRIMARY_CITY][:db] ) do |ssh|
      ssh.exec!( "rm -rf /tmp/#{@domain}-did" ) unless @domain.nil? || @domain == '*' || @domain == '.' || @domain == '..'
    end
  end
  
end