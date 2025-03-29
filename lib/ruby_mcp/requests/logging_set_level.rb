class RubyMCP::Requests::LoggingSetLevel < RubyMCP::Request
  def level
    @json.dig("params", "level")
  end

  def level_valid?
    RubyMCP::Capabilities::Logging::LEVELS.keys.include? level
  end
end
