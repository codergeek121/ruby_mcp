class RubyMCP::Handlers::CompletionComplete
  def handle(server, request)
    referenced_prompt = server.prompts.find_by_name(request.ref["name"])
    RubyMCP.logger.debug(referenced_prompt[:arguments])
    referenced_argument = referenced_prompt[:arguments].find { |argument| argument[:name] == request.argument_name }
    computed_values = referenced_argument[:completions].call(**request.param)

    server.answer(request,
      completion: {
        hasMore: false,
        total: computed_values.count,
        values: computed_values
      }
    )
  end
end
