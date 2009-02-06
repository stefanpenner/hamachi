require 'osx/cocoa'

class NetworkMenuItem < OSX::NSMenuItem
  def create(network,attrs)
    super_init

    image_path = attrs[:connected] ? 'online' : 'offline'
    image_name = NSBundle.mainBundle.pathForResource_ofType(image_path, 'png')
    image = NSImage.alloc.initWithContentsOfFile(image_name)  

    submenu = NetworkMenu.alloc.create(network)

    setImage image
    setTitle network
    setSubmenu submenu

    self
  end
  
  def init
  end
  
end

