require 'optparse'

require 'rubygems'
require 'msgpack-rpc'

module Gflocator
  class Main
    OPTS = {:daemonize=>true}

    def self.run
      new.run OPTS
    end

    def run options={}
      optparser = optparse options
      optparser.parse!
      host = options[:bind_host] || '0.0.0.0'
      port = options[:bind_port] || 7076

      raise RuntimeError, 'must run as root' unless Process.euid.zero?
      handler = Handler.new
      server = MessagePack::RPC::Server.new
      server.listen host, port, handler
      Process.daemon true if options[:daemonize] and !$debug
      server.run
    end

    def optparse options={}
      optparser = OptionParser.new
      optparser.on('--debug') {$debug = true; STDOUT.sync = true}
      optparser.on('-h', '--bind-host=HOST', 'bind to HOST address') {|a|
        options[:bind_host] = a}
      optparser.on('-p', '--bind-port=PORT', Integer, 'bind to port PORT') {|a|
        options[:bind_port] = a}
      class <<optparser
        attr_accessor :options
      end
      optparser.options = options
      optparser
    end
  end
end
