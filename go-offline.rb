require 'osx/cocoa'

class GoOffline < OSX::NSMenuItem
  def create(network)
    super_init
    @network=network
    setTitle 'Go Offline'
    setAction 'offline:'
    setTarget self
    self
  end
  
  def init
  end
  
  def offline(sender)
    Hamachi::CLI.go_offline(@network)
  end
end

