begin
  require 'rubygems'
rescue LoadError
end
require 'logger'

$log = Logger.new($stdout)
$log.level = Logger::DEBUG

module Hamachi
  class CLI < NSObject
    class << self
      def parse
        dump = `hamachi list`

        if dump =~ /Hamachi does not seem to be running/
          @connected = false
          @networks = nil
          return
        end
        @connected = true

        networks = {}
        states = {"*" => :online, "x" => :error}
        current_network = nil
        dump.each_line do |line|
          arr = line.split(/\s+/).reject{|e|e.empty?}

          state = arr[0]
          state = states[state] || :offline
          
          arr.shift unless state == :offline
          if line =~ /^...\[/ # If this is a network header...
            current_network = arr[0][1..-2] #remove the square brackets.
            networks[current_network] = {:state => state, :clients => []}
          else #this is a client listing.
            vpn_ip = arr[0]
            nick = arr[1] rescue nil
            # Sometimes we'll get a _real_ address, but no nick.
            nick = nil if nick =~ /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\:\d+/
            client={
              :ip    => vpn_ip,
              :nick  => nick,
              :state => state
            }
            networks[current_network][:clients].push(client)
          end
        end
        @networks = networks
      end

      def connected?; @connected; end
      def networks; @networks; end
      
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
        $log.debug "starting command #{command}"
        system "hamachi #{command} #{network if network}"
        $log.debug "finished command #{command}"
      end
    end
  end
  
  class GUI < NSObject
    def run
      statusbar = NSStatusBar.systemStatusBar 
      @@item = statusbar.statusItemWithLength(NSVariableStatusItemLength)  
      
      image_name = NSBundle.mainBundle.pathForResource_ofType('hamachi', 'png')
      image = NSImage.alloc.initWithContentsOfFile(image_name)  
      @@item.setImage(image)  

      Hamachi::GUI.regenerate
      self
    end

    def init
      super_init
      self.run
      self
    end
    
    def self.regenerate
      $log.debug "Hamachi::GUI.regenerate called"
      Hamachi::CLI.parse
      @@item.setMenu(self.build_menu)
    end

    private
    def self.build_menu
      $log.debug "Building menu"
      menu = NSMenu.alloc.init
      if Hamachi::CLI.networks
        Hamachi::CLI.networks.each do |network,attrs|
          menu.addItem(NetworkMenuItem.alloc.create(network,attrs))
        end
      end
      menu.addItem(NSMenuItem.separatorItem) if Hamachi::CLI.networks
      if Hamachi::CLI.connected?
        menu.addItem(Disconnect.alloc.init)
      else
        menu.addItem(Connect.alloc.init)
      end
      menu.addItem(GetNicks.alloc.init)
      menu.addItem(Quit.alloc.init)
      $log.debug "Finished building menu"
      menu
    end

  end
end

class HamachiTrayIcon < NSObject 
  def applicationDidFinishLaunching(aNotification) 
    Hamachi::CLI.start
    Hamachi::GUI.alloc.init

    Thread.new do
      loop do
        sleep 15
        Hamachi::GUI.regenerate
      end
    end
  end 

  def applicationShouldTerminate(sender)
    exit
  end
end 
