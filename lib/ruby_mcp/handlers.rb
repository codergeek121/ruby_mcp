module RubyMCP
  class Handlers
    def self.parse(json)
      parsed = JSON.parse(json)
      case parsed.fetch("method")
      when "initialize"
        Initialize
      when "notifications/initialized"
        NotificationsInitialized
      when "ping"
        Ping
      when "prompts/get"
        PromptsGet
      when "prompts/list"
        PromptsList
      when "completion/complete"
        CompletionComplete
      when "resources/list"
        ResourcesList
      when "resources/read"
        ResourcesRead
      when "logging/setLevel"
        LoggingSetLevel
      end.new
    end
  end
end
