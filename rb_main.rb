require 'osx/cocoa' 
include OSX 

def rb_main_init
  path = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
  rbfiles = Dir.entries(path).select {|x| /\.rb\z/ =~ x}
  rbfiles -= [ File.basename(__FILE__) ]
  rbfiles.each do |path|
    require( File.basename(path) )
  end
end
rb_main_init

module Hamachi
  class CLI < NSObject
    class << self
      # Return an array of network names.
      def networks
        dump = `hamachi list`
        networks = dump.select{|line| line =~ /^...\[/}
        networks.map!{|network| network.gsub(/^.*\[(.*?)\].*$/,'\1').strip}
        networks
      end
      
      # Make methods for each hamachi command that doesn't require a network param.
      %w{start stop login logout get-nicks}.each do |command|
        define_method(command.gsub('-','_').to_sym) do
          runcommand(command)
        end
      end

      # Make methods for each hamachi command that takes a network as a parameter.
      %w{create delete evict join leave go-online go-offline}.each do |command|
        define_method(command.gsub('-','_').to_sym) do |network|
          runcommand(command, network)
        end
      end
      
      private
      def runcommand(command, network=nil)
        system "hamachi #{command} #{network if network}"
      end
    end
  end
  
  class GUI < NSObject
    def self.run
      statusbar = NSStatusBar.systemStatusBar 
      item = statusbar.statusItemWithLength(NSVariableStatusItemLength)  
      
      image_name = NSBundle.mainBundle.pathForResource_ofType('hamachi', 'png')
      image = NSImage.alloc.initWithContentsOfFile(image_name)  
      item.setImage(image)  
      
      MenuController.alloc.create(item)

      Hamachi::CLI.start
    end
  end
end

class MenuController < NSObject 
  def create(container)
    @container = container 
    @menu = NSMenu.alloc.init
    @container.setMenu(@menu) 
    @items = [] 
    self.init
    self
  end
    
  def init 
    super_init 
    build
  end

  def build
    @menu.addItem(Connect.alloc.init)
    @menu.addItem(Disconnect.alloc.init)
    @menu.addItem(GoOnline.alloc.create("zzpluralzalpha"))
    @menu.addItem(GoOffline.alloc.create("zzpluralzalpha"))
    @menu.addItem(Quit.alloc.init)
  end

end 

class App < NSObject 
  def applicationDidFinishLaunching(aNotification) 
    Hamachi::CLI.start
    Hamachi::GUI.run
  end 

  def applicationShouldTerminate(sender)
    # I'd really rather it didn't.
    # Hamachi::CLI.stop
    sleep 1
    exit
  end
end 

NSApplication.sharedApplication 
NSApp.setDelegate(App.alloc.init) 
NSApp.run 
