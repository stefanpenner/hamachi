require 'osx/cocoa'

class Quit < OSX::NSMenuItem
  attr_accessor :title, :action, :target

  def init
    super_init
    @title = 'Quit'
    @action = 'terminate:'
    @target = OSX::NSApp
    self
  end
end
