require 'osx/cocoa'

class GoOnline < OSX::NSMenuItem
  def create(network)
    super_init
    @network = network
    if Hamachi::CLI.networks[network][:connected]
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

