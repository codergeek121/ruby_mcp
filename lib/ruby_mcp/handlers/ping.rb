class RubyMCP::Handlers::Ping
  def handle(server, request)
    server.answer(request, {})
  end
end
