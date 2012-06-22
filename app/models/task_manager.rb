class TaskManager < MigrationTask
  def initialize(domain,city)
    @tasks  = []
    @tasks << MoveDomainDataTask.new(domain,city)
    @tasks << MoveConferenceDataTask.new(domain,city)
    @tasks << MoveFilesystemDataTask.new(domain,city)
    @tasks << UpdatePhoneConfigTask.new(domain,city)
    @tasks << MoveDidDataTask.new(domain,city)
    @completed_tasks = []
  end
  
  def execute
    @tasks.each do |task|
      @completed_tasks << task
      task.execute
    end
  end
  
  def rollback
    @completed_tasks.each {|task| task.rollback }
  end
  
end
