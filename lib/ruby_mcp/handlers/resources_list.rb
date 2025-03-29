class RubyMCP::Handlers::ResourcesList
  def handle(server, request)
    server.answer(request, resources: server.resources.as_json)
  end
end
