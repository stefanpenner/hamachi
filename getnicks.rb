require 'osx/cocoa'

class GetNicks < OSX::NSMenuItem
  def init
    super_init
    setTitle 'Get Nicknames'
    setAction 'getnicks:'
    setTarget self
    self
  end
  
  def getnicks(sender)
    Thread.new do
      Hamachi::CLI.get_nicks
      sleep 5
      Hamachi::GUI.regenerate
    end
  end
end

