require 'osx/cocoa'

class Connect < OSX::NSMenuItem
  attr_accessor :title, :action, :target

  def init
    super_init
    @title = 'Connect'
    @action = 'online:'
    @target = self
    self
  end
  
  def online(sender)
    Hamachi::CLI.stop
    Hamachi::CLI.start
    Hamachi::CLI.login
    Hamachi::CLI.get_nicks
  end
end

