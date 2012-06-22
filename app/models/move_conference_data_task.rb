class MoveConferenceDataTask < MigrationTask
  require 'net/ssh'
  
  def initialize(domain,city)
    super    
    prepare_domain_directory
    
    @tasks = []
    @tasks << ExportConferenceSqlTask.new(domain,city)
    @tasks << CopyConferenceSqlTask.new(domain,city)
    @tasks << ImportConferenceSqlTask.new(domain,city)
    @tasks << ActivateConferenceSqlTask.new(domain,city)
    @completed_tasks = []
    
    logger "MoveConferenceDataTask created for: #{@domain}"
  end
  
  def execute
    @tasks.each do |task|
      @completed_tasks << task
      task.execute
    end
  end
  
  def rollback
    @completed_tasks.each {|task| task.rollback }
    remove_domain_directory
  end
  
  def prepare_domain_directory
    Net::SSH.start( *SSH_CREDENTIALS[PRIMARY_CITY][:db] ) do |ssh|
      ssh.exec!( "mkdir /tmp/#{@domain}-conference; chmod 777 /tmp/#{@domain}-conference" )
    end
  end
  
  def remove_domain_directory
    Net::SSH.start( *SSH_CREDENTIALS[PRIMARY_CITY][:db] ) do |ssh|
      ssh.exec!( "rm -rf /tmp/#{@domain}-conference" ) unless @domain.nil? || @domain == '*' || @domain == '.' || @domain == '..'
    end
  end
  
end