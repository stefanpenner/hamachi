require 'osx/cocoa'

class GoOnline < OSX::NSMenuItem
  attr_accessor :title, :action, :target

  def create(network)
    @network = network
    self.init
    self
  end
  
  def init
    super_init
    @title = 'Go Online'
    @action = 'online:'
    @target = self
    self
  end
  
  def online(sender)
    Hamachi::CLI.go_online(@network)
  end
end

