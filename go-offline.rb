require 'osx/cocoa'

class GoOffline < OSX::NSMenuItem
  def create(network)
    super_init
    @network=network
    unless Hamachi::CLI.networks[network][:connected]
      setState OSX::NSOnState
    end
    setTitle 'Go Offline'
    setAction 'offline:'
    setTarget self
    self
  end
  
  def init
  end
  
  def offline(sender)
    Thread.new do
      Hamachi::CLI.go_offline(@network)
      Hamachi::GUI.regenerate
    end
  end
end

