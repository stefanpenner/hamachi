require 'osx/cocoa'

class NetworkMenuItem < OSX::NSMenuItem
  attr_accessor :title

  def create(network,attrs)
    @name = network
    @connected = attrs[:connected]
    @imagepath = @connected ? 'online' : 'offline'
    self.init
    self
  end
  
  def init
    super_init
    @title = @name

    image_name = NSBundle.mainBundle.pathForResource_ofType(@imagepath, 'png')
    image = NSImage.alloc.initWithContentsOfFile(image_name)  
    self.setImage(image)

    submenu = NetworkMenu.alloc.create(@name)
    self.setSubmenu(submenu)
    self
  end
  
end

