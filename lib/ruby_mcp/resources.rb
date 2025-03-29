module RubyMCP
  Resource = Data.define(:uri, :name, :description, :mime_type, :reader)

  class Resources
    def initialize
      @resources = {}
    end

    def add(uri:, name:, description: nil, mime_type: nil, reader: nil)
      @resources[uri] = Resource.new(uri, name, description, mime_type, reader)
    end

    def find(uri)
      @resources[uri]
    end

    def as_json
      @resources.map do |uri, resource|
        {
          uri: uri,
          name: resource.name,
          description: resource.description,
          mimeType: resource.mime_type
        }
      end
    end
  end
end
