require "option_parser"

module Crystalmon
  class CLI
    def initialize
      port = Config.target_port
      command = Config.command

      OptionParser.parse! do |parser|
        parser.banner = "Usage: crystalmon [file]"
        parser.on("-p PORT", "--port PORT", "Port to foward") { |p| port = p.to_i }
        parser.on("-c COMMAND", "--port COMMAND", "Command to run") { |c| command = c }
      end

      target = ARGV[0]?

      spawn do
        Runner.new("#{command} #{target}")
      end

      proxy = Proxy.new(5000, port)
      proxy.listen
    end
  end
end
