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
end
