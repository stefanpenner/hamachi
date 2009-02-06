require 'osx/cocoa'

class Quit < OSX::NSObject
  
  attr_accessor :name,
  :method,
  :shortcut,
  :keyEquivalentModifierMask,
  :target

  def init
    super_init
    @name = 'Quit'
    @method = 'terminate:'
    @shortcut = 'q'
    @keyEquivalentModifierMask = NSCommandKeyMask
    @target = NSApp
    self
  end
end
