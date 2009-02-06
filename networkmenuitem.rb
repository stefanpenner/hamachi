require 'osx/cocoa'

class NetworkMenuItem < OSX::NSMenuItem
  attr_accessor :title, :submenu

  def create(name)
    @name = name
    self.init
    self
  end
  
  def init
    super_init
    @title = @name
    @submenu = NetworkMenu.alloc.create(@name)
    self
  end
  
end

