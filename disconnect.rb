require 'osx/cocoa'

class Disconnect < OSX::NSObject
  attr_accessor :name, :method, :shortcut, :keyEquivalentModifierMask, :target

  def init
    super_init
    @name = 'Disconnect'
    @method = 'offline:'
    @shortcut = 'd'
    @target = self
    self
  end
  
  def offline(sender)
    Hamachi::CLI.stop
  end
end

