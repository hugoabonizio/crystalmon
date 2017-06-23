require "socket"
require "http"

module Crystalmon
  class Proxy
    def initialize(port : Int32, target_port : Int32)
      @server = HTTP::Server.new(port) do |ctx|
        handle(ctx)
      end
      @target_port = target_port
    end

    def listen
      @server.listen
    end

    private def handle(ctx)
      request = ctx.request
      target_connection = nil
      until target_connection
        begin
          target_connection = HTTP::Client.new("127.0.0.1", Config.target_port)
        rescue e
          sleep 100.milliseconds
        end
      end

      if target = target_connection
        finished = false
        until finished
          begin
            target.exec(request) do |response|
              ctx.response.headers.merge!(response.headers)
              response.consume_body_io
              ctx.response << response.body
              finished = true
            end
          rescue e
            sleep 100.milliseconds
          end
        end
      end
    end
  end
end
