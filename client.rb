require 'osx/cocoa'

class Client < OSX::NSMenuItem
  def create(client)
    super_init

    name = client[:nick] || client[:ip]

    image_path = client[:connected] ? 'online' : 'offline'
    image_name = NSBundle.mainBundle.pathForResource_ofType(image_path, 'png')
    image = NSImage.alloc.initWithContentsOfFile(image_name)  

    setImage image
    setTitle name
    setTarget self

    self
  end
  
  def init
  end
end
