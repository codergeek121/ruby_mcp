require "test_helper"

class TestResourcesCapability < ServerTest
  include OperationPhase

  def test_list_resources
    @server.add_resource(
      uri: "file:///demo1.txt",
      name: "demo1.txt",
      description: "first demo",
      mime_type: "text/plain"
    )

    @server.add_resource(
      uri: "file:///demo2.txt",
      name: "demo2.txt",
      description: "second demo",
      mime_type: "text/plain"
    )

    @transport.client_message(
      jsonrpc: "2.0",
      id: 1,
      method: "resources/list",
      params: {}
    )

    @transport.process_message

    assert_last_response(
      jsonrpc: "2.0",
      id: 1,
      result: {
        resources: [
          {
            uri: "file:///demo1.txt",
            name: "demo1.txt",
            description: "first demo",
            mimeType: "text/plain"
          },
          {
            uri: "file:///demo2.txt",
            name: "demo2.txt",
            description: "second demo",
            mimeType: "text/plain"
          }
        ]
      }
    )
  end

  def test_read_resources
    @server.add_resource(
      uri: "file:///demo1.txt",
      name: "demo1.txt",
      description: "first demo",
      mime_type: "text/plain",
      reader: ->(resource) {
        "The first demo content of #{resource.name}"
      }
    )

    @transport.client_message(
      jsonrpc: "2.0",
      id: 1,
      method: "resources/read",
      params: {
        uri: "file:///demo1.txt"
      }
    )

    @transport.process_message

    assert_last_response(
      jsonrpc: "2.0",
      id: 1,
      result: {
        contents: [
          {
            uri: "file:///demo1.txt",
            mimeType: "text/plain",
            text: "The first demo content of demo1.txt"
          }
        ]
      }
    )
  end

  def test_read_resources_not_found
    @server.add_resource(
      uri: "file:///demo1.txt",
      name: "demo1.txt",
      description: "first demo",
      mime_type: "text/plain",
      reader: ->(resource) {
        "The first demo content of #{resource.name}"
      }
    )

    @transport.client_message(
      jsonrpc: "2.0",
      id: 1,
      method: "resources/read",
      params: {
        uri: "file:///not-found.txt"
      }
    )

    @transport.process_message

    assert_last_response(
      {
        jsonrpc: "2.0",
        id: 1,
        error: {
          code: -32002,
          message: "Resource not found",
          data: {
            uri: "file:///not-found.txt"
          }
        }
      }
    )
  end

  def test_read_template
    @server.add_resource_template(
      uri_template: "https://{host}.de",
      name: "german_website",
      description: "Every german website",
      mime_type: "text/html",
      reader: ->(resource) {
        "The first demo content of #{resource.name}"
      }
    )

    @transport.client_message(
      jsonrpc: "2.0",
      id: 1,
      method: "resources/read",
      params: {
        uri: "https://example.de"
      }
    )

    @transport.process_message

    assert_last_response(
      jsonrpc: "2.0",
      id: 1,
      result: {
        contents: [
          {
            uri: "https://example.de",
            mimeType: "text/html",
            text: "The first demo content of german_website"
          }
        ]
      }
    )
  end

  def test_list_templates
    @server.add_resource_template(
      uri_template: "https://{host}.de",
      name: "german_website",
      description: "Every german website",
      mime_type: "text/html",
      reader: ->(resource) {
        "The first demo content of #{resource.name}"
      }
    )

    @server.add_resource_template(
      uri_template: "https://{host}.com",
      name: "com_website",
      description: "Every com website",
      mime_type: "text/html",
      reader: ->(resource) {
        "The first demo content of #{resource.name}"
      }
    )

    @transport.client_message(
      jsonrpc: "2.0",
      id: 1,
      method: "resources/templates/list",
    )

    @transport.process_message

    assert_last_response(
      "jsonrpc": "2.0",
      "id": 1,
      "result": {
        "resourceTemplates": [
          {
            uriTemplate: "https://{host}.de",
            name: "german_website",
            description: "Every german website",
            mimeType: "text/html"
          },
          {
            uriTemplate: "https://{host}.com",
            name: "com_website",
            description: "Every com website",
            mimeType: "text/html"
          }
        ]
      }
    )
  end
end
