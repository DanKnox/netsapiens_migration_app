class ImportConferenceSqlTask < MigrationTask
  require 'net/ssh'
  
  def initialize(domain,city)
    super
    @export_sql = ExportConferenceSqlTask.new(domain,city)
  end
  
  def execute
    import_sql_files
  end
  
  def import_sql_files
    import_user = SSH_CREDENTIALS[@city][:model].connection_config[:username]
    import_pass = SSH_CREDENTIALS[@city][:model].connection_config[:password]
    Net::SSH.start( *SSH_CREDENTIALS[@city][:db] ) do |ssh|
      @export_sql.export_tables.each do |filename|
        ssh.exec!("mysqlimport --local --user=#{import_user} --password=#{import_pass} NcsDomain /tmp/#{@domain}-conference/#{filename.to_s}")
      end
    end
  end
  
end