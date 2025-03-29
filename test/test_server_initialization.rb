require "test_helper"

class TestServerInitialization < ServerTest
  def test_initialization
    assert @server.lifecycle.initialization_pending?
    @transport.client_message(
      id: 1337,
      jsonrpc: "2.0",
      method: "initialize",
      params: {
        protocolVersion: "2024-11-05"
      },
      clientInfo: {
        name: "ExampleClient",
        version: "1.0.0"
      }
    )

    @transport.process_message
    assert @server.lifecycle.initialize_response_sent?

    assert_last_response(
      id: 1337,
      jsonrpc: "2.0",
      result: {
        protocolVersion: "2024-11-05",
        capabilities: {
          logging: {},
          prompts: {
            listChanged: true
          },
          resources: {},
          tools: {
            listChanged: true
          }
        },
        serverInfo: {
          name: "RubyMCP",
          version: RubyMCP::VERSION
        }

      }
    )

    @transport.client_message(
      id: 1337,
      jsonrpc: "2.0",
      method: "notifications/initialized"
    )
    @transport.process_message
    assert @server.lifecycle.operation_phase?
  end
end
