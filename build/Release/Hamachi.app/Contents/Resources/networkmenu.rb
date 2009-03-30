require 'osx/cocoa'

class NetworkMenu < OSX::NSMenu
  def create(name,attrs)
    super_init
    if attrs[:state] == :online
      addItem(GoOffline.alloc.create(name))
    else
      addItem(GoOnline.alloc.create(name))
    end
    addItem(NSMenuItem.separatorItem)
    attrs[:clients].each do |client|
      self.addItem(Client.alloc.create(client))
    end
    self
  end
  
  def init
  end
end
