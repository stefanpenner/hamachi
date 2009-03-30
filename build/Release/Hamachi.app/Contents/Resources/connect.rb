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
    Thread.new do
      Hamachi::CLI.start
      Hamachi::CLI.login
      Hamachi::CLI.get_nicks
      Hamachi::GUI.regenerate
    end
  end
end

