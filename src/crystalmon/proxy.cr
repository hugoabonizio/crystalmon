require "socket"

module Crystalmon
  class Proxy
    def initialize(port : Int32, target_port : Int32)
      @server = TCPServer.new(port)
      @target_port = target_port
    end

    def listen
      while client = @server.accept?
        spawn handle(client)
      end
    end

    private def handle(ctx)
      puts "request..."
      socket = TCPSocket.new("127.0.0.1", Config.target_port)
      spawn { IO.copy(ctx, socket) }

      # TODO this seems to hang forever
      spawn { IO.copy(socket, ctx) }
    end
  end
end
