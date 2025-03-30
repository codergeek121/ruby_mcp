class RubyMCP::Handlers::ResourcesRead
  def handle(server, request)
    resources = server.resources.find(request.uri)
    if resources.any?
      server.answer(request,
        contents: resources.map do |resource|
          {
            uri: request.uri,
            mimeType: resource.mime_type,
            text: resource.reader.call(resource)
          }
        end
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
