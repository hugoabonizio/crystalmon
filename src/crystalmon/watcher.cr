# TODO
# => Use inotify or some native methods

module Crystalmon
  class Watcher
    @files = Hash(String, String).new { "" }

    def initialize(pattern = "**/*.{cr,ecr}")
      Dir.glob(pattern) do |file|
        @files[file] = timestamp(file)
      end
    end

    def listen(&block)
      loop do
        sleep 300.milliseconds
        changed = false
        new_files = Hash(String, String).new { "" }
        @files.each do |key, value|
          changed = true if timestamp(key) != value
          new_files[key] = timestamp(key)
        end

        @files = new_files
        yield if changed
      end
    end

    private def timestamp(file : String)
      File.stat(file).mtime.to_s("%Y%m%d%H%M%S")
    end
  end
end
