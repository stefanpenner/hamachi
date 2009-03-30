require 'osx/cocoa'

class Disconnect < OSX::NSMenuItem
  def init
    super_init
    setTitle 'Disconnect'
    setAction 'offline:'
    setTarget self
    self
  end
  
  def offline(sender)
    Thread.new do
      Hamachi::CLI.stop
      Hamachi::GUI.regenerate
    end
  end
end

