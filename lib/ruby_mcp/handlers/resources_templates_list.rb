class RubyMCP::Handlers::ResourcesTemplatesList < RubyMCP::Handlers
  def handle(server, request)
    server.answer(request, resourceTemplates: server.resources.templates.map do |template, value|
      {
        uriTemplate: template,
        name: value.name,
        description: value.description,
        mimeType: value.mime_type
      }
    end)
  end
end
