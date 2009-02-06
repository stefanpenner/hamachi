require 'osx/cocoa'

class GoOnline < OSX::NSObject
  attr_accessor :name, :method, :shortcut, :keyEquivalentModifierMask, :target

  def init
    super_init
    @name = 'Go Online'
    @method = 'online:'
	@shortcut = 'n'
    @target = self
    self
  end
  
  def online(sender)
    Hamachi::CLI.go_online
  end
end

