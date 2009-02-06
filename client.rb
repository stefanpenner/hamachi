require 'osx/cocoa'

class Client < OSX::NSMenuItem
  attr_accessor :title, :target

  def create(name)
    @name = name
    self.init
    self
  end
  
  def init
    super_init
    @title = @name
    @target = self
    self
  end
end
