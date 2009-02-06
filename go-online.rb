require 'osx/cocoa'

class GoOnline < OSX::NSMenuItem
  def create(network)
    super_init
    @network = network
    setTitle 'Go Online'
    setAction 'online:'
    setTarget self
    self
  end
  
  def init
  end
  
  def online(sender)
    Hamachi::CLI.go_online(@network)
  end
end

