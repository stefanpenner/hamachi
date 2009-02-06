require 'osx/cocoa'

class Quit < OSX::NSMenuItem
  def init
    super_init
    setTitle 'Quit'
    setAction 'terminate:'
    setTarget OSX::NSApp
    self
  end
end
