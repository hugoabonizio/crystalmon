require "colorize"

module Crystalmon
  class Runner
    @command : String
    @arg : Array(String)?
    @env : Process::Env

    @process : Process?
    @sub_process : Process?

    def initialize(command, arg)
      @command = command
      @arg = if arg
               ["run", arg]
             else
               nil
             end
      process_port = random_port
      Config.target_port = process_port
      @env = {"PORT" => process_port.to_s}
      spawn do
        @process = ::Process.new(@command, args: @arg, env: @env, output: STDOUT, error: STDOUT)
      end

      puts "Running \"#{command}\" on port #{process_port}...".colorize(:green)

      spawn do
        watcher = Watcher.new
        watcher.listen do
          puts "Restarting..."
          restart
        end
      end
    end

    def restart
      # TODO find a better way to kill all subprocesses
      begin
        if process = @process
          puts "killing #{process.pid}"
          kill_command = <<-HEREDOC
list_descendants() {
  local children=$(ps -o pid= --ppid "$1")
  for pid in $children
  do
    list_descendants "$pid"
  done
  echo "$children"
}
kill $(echo $(list_descendants #{process.pid}))
HEREDOC
          Process.run(kill_command, shell: true)
        end
      rescue e
        puts e.inspect
      ensure
        @process = ::Process.new(@command, args: @arg, env: @env, output: STDOUT, error: STDOUT)
      end
    end

    private def random_port
      3000 + rand(60_000)
    end
  end
end
