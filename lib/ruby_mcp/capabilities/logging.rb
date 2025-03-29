module RubyMCP::Capabilities::Logging
  LEVELS = {
    "debug" =>     0,
    "info" =>      1,
    "notice" =>    2,
    "warning" =>   3,
    "error" =>     4,
    "critical" =>  5,
    "alert" =>     6,
    "emergency" => 7
  }

  def logging_verbosity
    @level ||= @default_logging_verbosity
  end

  def logging_verbosity=(level)
    @level = level
  end

  LEVELS.each do |name, value|
    define_method("send_#{name}_log_message") do |msg|
      send_message(
        jsonrpc: "2.0", method: "notifications/message", params: msg.merge(level: name)) if value <= LEVELS[logging_verbosity]
    end
  end
end
