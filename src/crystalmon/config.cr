module Crystalmon
  class Config
    @@port = 5000
    @@target_port = 0
    @@command = "crystal run"

    def self.command
      @@command
    end

    def self.port
      @@port
    end

    def self.port=(port)
      @@port = port
    end

    def self.target_port
      @@target_port
    end

    def self.target_port=(port)
      @@target_port = port
    end
  end
end
