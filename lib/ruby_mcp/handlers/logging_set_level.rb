class RubyMCP::Handlers::LoggingSetLevel
  def handle(server, request)
    if request.level_valid?
      server.logging_verbosity = request.level
      server.answer(request, {})
    else
      server.error(request, code: -32602, message: "Invalid loglevel")
    end
  end
end
