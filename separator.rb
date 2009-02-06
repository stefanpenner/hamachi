require 'osx/cocoa'

class Separator < OSX::NSMenuItem
  
  attr_accessor :isSeparatorItem, :target

  def init
    super_init
    @isSeparatorItem = true
    @target = NSApp
    self
  end
end
