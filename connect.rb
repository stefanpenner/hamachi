require 'osx/cocoa'

class Connect < OSX::NSMenuItem
  def init
    super_init
    setTitle 'Connect'
    setAction 'online:'
    setTarget self
    self
  end
  
  def online(sender)
    Hamachi::CLI.start
    Hamachi::CLI.login
    Hamachi::CLI.get_nicks
  end
end

