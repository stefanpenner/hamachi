require 'osx/cocoa'

class Client < OSX::NSMenuItem
  attr_accessor :title, :target

  def create(client)
    @client = client
    @connected = @client[:connected]
    @name = client[:nick] || client[:ip]

    @imagepath = @connected ? 'online' : 'offline'

    self.init
    self
  end
  
  def init
    super_init
    @title = @name
    @target = self

    image_name = NSBundle.mainBundle.pathForResource_ofType(@imagepath, 'png')
    image = NSImage.alloc.initWithContentsOfFile(image_name)  
    self.setImage(image)

    self
  end
end
