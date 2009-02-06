require 'osx/cocoa'

class GoOffline < OSX::NSObject
  attr_accessor :name, :method, :shortcut, :keyEquivalentModifierMask, :target

  def init
    super_init
    @name = 'Go Offline'
    @method = 'offline:'
	@shortcut = 'f'
    @target = self
    self
  end
  
  def offline(sender)
    Hamachi::CLI.go_offline
  end
end

