require "json"
require "securerandom"
require "logger"
require "zeitwerk"

loader = Zeitwerk::Loader.for_gem
loader.inflector.inflect("ruby_mcp" => "RubyMCP")
loader.setup

module RubyMCP
  def self.logger
    @logger ||= ::Logger.new($stderr).tap do |log|
      log.formatter = proc do |severity, datetime, progname, msg|
        "[RubyMCP] #{severity[0]}, #{msg}\n"
      end
    end
  end
end

loader.eager_load
