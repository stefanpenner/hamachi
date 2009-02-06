require 'osx/cocoa'

class Disconnect < OSX::NSMenuItem
  attr_accessor :title, :action, :target

  def init
    super_init
    @title = 'Disconnect'
    @action = 'offline:'
    @target = self
    self
  end
  
  def offline(sender)
    Hamachi::CLI.stop
  end
end

