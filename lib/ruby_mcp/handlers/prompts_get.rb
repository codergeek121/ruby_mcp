class RubyMCP::Handlers::PromptsGet
  def handle(server, request)
    if prompt = server.prompts.find_by_name(request.name)
      required_arguments = prompt[:arguments].filter_map { _1[:name].to_sym if _1[:required] }
      all_required_arguments_given = (required_arguments - request.arguments.keys).empty?
      if all_required_arguments_given
        server.answer(request, **prompt[:result].call(**request.arguments))
      else
        server.error(request, code: -32602, message: "Missing required param")
      end
    else
      server.error(request, code: -32602, message: "Invalid params")
    end
  end
end
