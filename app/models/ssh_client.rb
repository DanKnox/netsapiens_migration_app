class SshClient
  require 'net/ssh'

  def initialize(city,server)
    @session = Net::SSH.start( *SSH_CREDENTIALS[city][server] )
  end
  
  def destroy!
    @session.close
  end
  
  def execute(command)
    @session.exec!(command)
  end
end