module Crystalmon
  class Runner
    def initialize(command)
      process_port = random_port
      Config.target_port = process_port
      env = {"PORT" => process_port.to_s}
      @process = ::Process.new(command, env: env, shell: true, error: true)
      puts "Running \"#{command}\" on port #{process_port}..."
    end

    private def random_port
      3000 + rand(60_000)
    end
  end
end
