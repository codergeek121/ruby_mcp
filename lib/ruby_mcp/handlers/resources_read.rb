class RubyMCP::Handlers::ResourcesRead
  def handle(server, request)
    if resource = server.resources.find(request.uri)
      server.answer(request,
        contents: [ {
          uri: resource.uri,
          mimeType: resource.mime_type,
          text: resource.reader.call(resource)
        } ]
      )
    else
      server.error(
        request,
        code: -32002,
        message: "Resource not found",
        data: {
          uri: request.uri
        }
      )
    end
  end
end
