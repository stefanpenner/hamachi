require 'osx/cocoa'

class GoOnline < OSX::NSMenuItem
  def create(network)
    super_init
    @network = network
    unless Hamachi::CLI.networks[network][:state] == :offline
      setState OSX::NSOnState
    end
    setTitle 'Go Online'
    setAction 'online:'
    setTarget self
    self
  end
  
  def init
  end
  
  def online(sender)
    Thread.new do
      Hamachi::CLI.go_online(@network)
      Hamachi::GUI.regenerate
    end
  end
end

