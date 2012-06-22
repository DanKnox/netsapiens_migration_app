class ImportSqlTask < MigrationTask
  require 'net/ssh'
  
  def initialize(domain,city)
    super
    @export_sql = ExportSqlTask.new(domain,city)
  end
  
  def execute
    import_sql_files
    update_territory
  end
  
  def import_sql_files
    import_user = SSH_CREDENTIALS[@city][:model].connection_config[:username]
    import_pass = SSH_CREDENTIALS[@city][:model].connection_config[:password]
    Net::SSH.start( *SSH_CREDENTIALS[@city][:db] ) do |ssh|
      @export_sql.export_tables.each do |filename|
        ssh.exec!("mysqlimport --local --user=#{import_user} --password=#{import_pass} SiPbxDomain /tmp/#{@domain}/#{filename.to_s}")
      end
    end
  end
  
  def update_territory
    SSH_CREDENTIALS[@city][:model].connection.execute "UPDATE  `SiPbxDomain`.`domains_config` SET  `territory` =  'Vintalk' WHERE  `domains_config`.`domain` =  '#{@domain}' AND territory = 'vinculum.com';"
  end
  
end