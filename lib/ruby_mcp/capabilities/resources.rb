module RubyMCP::Capabilities::Resources
  def add_resource(...)
    @resources.add(...)
  end

  def add_resource_template(uri_template:, name:, description:, mime_type:, reader:)
    @resources.add_resource_template(uri_template:, name:, description:, mime_type:, reader:)
  end
end
