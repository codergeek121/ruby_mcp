class RubyMCP::Handlers::Initialize
  def handle(server, request)
    server.answer(request,
      protocolVersion: "2024-11-05",
      capabilities: {
        logging: {},
        prompts: {
          listChanged: true
        },
        resources: {},
        tools: {
          listChanged: true
        }
      },
      serverInfo: {
        name: "RubyMCP",
        version: RubyMCP::VERSION
      }
    )
    server.lifecycle.initialize_response_sent!
  end
end
