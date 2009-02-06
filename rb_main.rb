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
      def parse
        dump = `hamachi list`
        networks = {}
        current_network = nil
        dump.each_line do |line|
          if line =~ /^...\[/ # If this is a network header...
            arr = line.split(/\s+/).reject{|e|e.empty?}
            network_connected = (arr[0] == "*")
            arr.shift if network_connected
            current_network = arr[0][1..-2] #remove the square brackets.
            networks[current_network] = {:connected => network_connected, :clients => []}
          else #this is a client listing.
            arr = line.split(/\s+/).reject{|e|e.empty?}
            client_connected = (arr[0] == "*")
            arr.shift if client_connected
            client_vpn_ip = arr[0]
            client_nick = arr[1] rescue client_vpn_ip
            networks[current_network][:clients].push({
                                                       :ip => client_vpn_ip,
                                                       :nick => client_nick,
                                                       :connected => client_connected})
          end
        end

        @networks = networks
      end

      def networks
        parse if !@networks
        @networks
      end

      def clients(network)
        parse if !@networks
        @networks[network][:clients]
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
      
      menu = NSMenu.alloc.init
      item.setMenu(menu)
      Hamachi::CLI.networks.each do |network,attrs|
        menu.addItem(NetworkMenuItem.alloc.create(network,attrs))
      end
      menu.addItem(Separator.alloc.init)
      menu.addItem(Connect.alloc.init)
      menu.addItem(Disconnect.alloc.init)
      menu.addItem(Quit.alloc.init)
      
      Hamachi::CLI.start
    end
  end
end

class App < NSObject 
  def applicationDidFinishLaunching(aNotification) 
    Hamachi::CLI.start
    Hamachi::GUI.run
  end 

  def applicationShouldTerminate(sender)
    exit
  end
end 

NSApplication.sharedApplication 
NSApp.setDelegate(App.alloc.init) 
NSApp.run 
