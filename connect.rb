require 'osx/cocoa'

class Connect < OSX::NSObject
  attr_accessor :name, :method, :shortcut, :keyEquivalentModifierMask, :target

  def init
    super_init
    @name = 'Connect'
    @method = 'online:'
    @shortcut = 'c'
    @target = self
    self
  end
  
  def online(sender)
    Hamachi::CLI.stop
    Hamachi::CLI.start
    Hamachi::CLI.login
    Hamachi::CLI.get_nicks
  end
end

