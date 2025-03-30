module RubyMCP
  Resource = Data.define(:uri, :name, :description, :mime_type, :reader)
  ResourceTemplate = Data.define(:uri_template, :name, :description, :mime_type, :reader)

  class Resources
    def initialize
      @resources = {}
      @resource_templates = {}
    end

    def add(uri:, name:, description: nil, mime_type: nil, reader: nil)
      @resources[uri] = Resource.new(uri, name, description, mime_type, reader)
    end

    def find(uri)
      [ @resources[uri] ].concat(find_in_templates(uri).map(&:last)).compact
    end

    def add_resource_template(uri_template:, **args)
      @resource_templates[uri_template] = ResourceTemplate.new(
        uri_template: Addressable::Template.new(uri_template),
        **args
      )
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

    def templates
      @resource_templates
    end

    private

    def find_in_templates(uri)
      addressable_uri = Addressable::URI.parse(uri)
      @resource_templates.find_all do |template, resource_template|
        resource_template.uri_template.extract(addressable_uri)
      end
    end
  end
end
