require 'osx/cocoa'

class NetworkMenu < OSX::NSMenu
  def create(name)
    super_init
    addItem(GoOnline.alloc.create(name))
    addItem(GoOffline.alloc.create(name))
    addItem(NSMenuItem.separatorItem)
    Hamachi::CLI.clients(name).each do |client|
      self.addItem(Client.alloc.create(client))
    end
    self
  end
  
  def init
  end
end
