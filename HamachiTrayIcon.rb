module Hamachi
  class CLI < NSObject
    class << self
      def parse
        dump = `hamachi list`
        networks = {}
        current_network = nil
        dump.each_line do |line|
          arr = line.split(/\s+/).reject{|e|e.empty?}
          connected = (arr[0] == "*")
          arr.shift if connected
          if line =~ /^...\[/ # If this is a network header...
            current_network = arr[0][1..-2] #remove the square brackets.
            networks[current_network] = {:connected => connected, :clients => []}
          else #this is a client listing.
            vpn_ip = arr[0]
            nick = arr[1] rescue nil
            # Sometimes we'll get a _real_ address, but no nick.
            nick = nil if nick =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\:\d+/
            client={
              :ip        => vpn_ip,
              :nick      => nick,
              :connected => connected
            }
            networks[current_network][:clients].push(client)

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
      menu.addItem(NSMenuItem.separatorItem)
      menu.addItem(Connect.alloc.init)
      menu.addItem(Disconnect.alloc.init)
      menu.addItem(Quit.alloc.init)
      
      Hamachi::CLI.start
    end
  end
end

class HamachiTrayIcon < NSObject 
  def applicationDidFinishLaunching(aNotification) 
    Hamachi::CLI.start
    Hamachi::GUI.run
  end 

  def applicationShouldTerminate(sender)
    exit
  end
end 
