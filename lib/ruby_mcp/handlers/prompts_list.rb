class RubyMCP::Handlers::PromptsList
  def handle(server, request)
    server.answer(request, prompts: server.prompts.list)
  end
end
