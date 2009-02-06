require 'osx/cocoa'

class NetworkMenu < OSX::NSMenu

  def create(name)
    @name = name
    self.init
    self
  end
  
  def init
    super_init
    build
    self
  end

  def build
    self.addItem(GoOnline.alloc.create(@name))
    self.addItem(GoOffline.alloc.create(@name))
  end
    
end
