require 'osx/cocoa'

class Submenu < OSX::NSObject
  attr_accessor :name, :method, :shortcut, :keyEquivalentModifierMask

  def init
    super_init
    @name = 'Go Offline'
    @method = 'offline:'
    @shortcut = 'f'
    self
  end
  
  def offline(sender)
    Hamachi::CLI.go_offline
  end
end

