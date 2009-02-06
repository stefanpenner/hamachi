
require 'osx/cocoa' 
include OSX 

module Hamachi
  class CLI < NSObject
    def self.start
	  system('hamachi start')
	end
  
    def self.stop
      system('hamachi stop') 
	end
	
	def self.get_nicks
	  system('hamachi get-nicks')
	end
	
	def self.go_online(group)
	  system("hamachi go-online #{group}")
	end
	
	def self.go_offline(group)
	  system("hamachi go-offline #{group}")
	end
	def self.list
	  # todo
	end
  end
  
  class GUI < NSObject
    def self.run
      statusbar = NSStatusBar.systemStatusBar 
      item = statusbar.statusItemWithLength(NSVariableStatusItemLength)  
  	
	  image_name = NSBundle.mainBundle.pathForResource_ofType('hamachi', 'png')
      image = NSImage.alloc.initWithContentsOfFile(image_name)  
      item.setImage(image)  
  
      # build menu
	  #
	  # menu items are directly tied to there behaviour
	  #
	  
      MenuController.alloc.init do |menu|
        menu.add_menu_to(item)
		menu << Online.alloc.init
		menu << Offline.alloc.init
		menu << GetNicks.alloc.init
        menu << Quiter.alloc.init
      end
	  Hamachi::CLI.start
    end
  end
end

class Quiter < NSObject
  
  attr_accessor :name,
                :method,
                :shortcut,
                :keyEquivalentModifierMask,
                :target

  def init
    super_init
    @name = 'Quit'
    @method = 'terminate:'
    @shortcut = 'q'
    @keyEquivalentModifierMask = NSCommandKeyMask
    @target = NSApp
    self
  end
end

class Online < NSObject

   attr_accessor :name,
                :method,
                :shortcut,
                :keyEquivalentModifierMask,
                :target

  def init
    super_init
    @name = 'Go Online'
    @method = 'online:'
    @shortcut = 'o'
    @target = self
    self
  end
  
  def online(sender)
    Hamachi::CLI.go_online('zzpluralzalpha')
  end
end

class Offline < NSObject

  attr_accessor :name,
				:method,
				:shortcut,
				:keyEquivalentModifierMask,
				:target
				
  def init
    super_init
    @name = 'Go Offline'
    @method = 'offline:'
    @shortcut = 'f'
    @target = self
    self
  end
  
  def offline(sender)
    Hamachi::CLI.go_offline('zzpluralzalpha')
  end
end

class Stopper < NSObject

   attr_accessor :name,
                :method,
                :shortcut,
                :keyEquivalentModifierMask,
                :target

  def init
    super_init
    @name = 'Stop'
    @method = 'stop:'
    @shortcut = 't'
    @target = self
    self
  end
  
  def stop(sender)
    Hamachi::CLI.stop
  end
end

class GetNicks < NSObject

   attr_accessor :name,
                :method,
                :shortcut,
                :keyEquivalentModifierMask,
                :target

  def init
    super_init
    @name = 'Get Nicks'
    @method = 'get:'
    @shortcut = 'g'
    @target = self
    self
  end
  
  def get(sender)
    Hamachi::CLI.get_nicks
  end
end

class MenuController < NSObject 
  def init 
    super_init 
    @items =  [] 
    yield self if block_given?
	build
  end

  def add_menu_to(container) 
    @container = container 
    @menu = NSMenu.alloc.init 
    @container.setMenu(@menu) 
  end 
  
  def <<(item)
    @items << item
  end
 
  def build
    @items.each do |item|
      i = @menu.addItemWithTitle_action_keyEquivalent(item.name,item.method,item.shortcut)
      i.setKeyEquivalentModifierMask(item.keyEquivalentModifierMask) if item.respond_to?(:keyEquivalentModifierMask)

      if item.respond_to?(:target) && item.target
        i.setTarget(item.target)
      else
        i.setTarget(self)
      end
    end
  end
end 

class App < NSObject 
  def applicationDidFinishLaunching(aNotification) 
    Hamachi::CLI.start
	Hamachi::GUI.run
  end 

  def applicationShouldTerminate(sender)
    Hamachi::CLI.stop
	sleep 1
	exit
  end
end 

NSApplication.sharedApplication 
NSApp.setDelegate(App.alloc.init) 
NSApp.run 