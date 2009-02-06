require 'osx/cocoa'

class GoOffline < OSX::NSMenuItem
  attr_accessor :title, :action, :target
  
  def create(network)
    @network=network
    self.init
    self
  end
  
  def init
    super_init
    @title = 'Go Offline'
    @action = 'offline:'
    @target = self
    self
  end
  
  def offline(sender)
    Hamachi::CLI.go_offline(@network)
  end
end

