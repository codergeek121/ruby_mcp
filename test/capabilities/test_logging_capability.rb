require "test_helper"

class TestCompletion < ServerTest
  include OperationPhase

  def test_logging_verbosity_can_be_set
    @transport.client_message(
      jsonrpc: "2.0",
      id: 1,
      method: "logging/setLevel",
      params: {
        level: "alert"
      }
    )

    @transport.process_message

    assert_equal "alert", @server.logging_verbosity

    assert_last_response(
      id: 1,
      jsonrpc: "2.0",
      result: {}
    )

    @server.send_alert_log_message(
      logger: "demo",
      data: {
        error: "Some error",
        details: {
          foo: "bar"
        }
      }
    )

    @server.send_alert_log_message(
      logger: "demo",
      data: {
        error: "Some error",
        details: {
          foo: "bar"
        }
      }
    )

    @server.send_emergency_log_message(
      logger: "demo",
      data: {
        error: "Some error",
        details: {
          foo: "bar"
        }
      }
    )

    assert_last_response(
      jsonrpc: "2.0",
      method: "notifications/message",
      params: {
        level: "alert",
        logger: "demo",
        data: {
          error: "Some error",
          details: {
            foo: "bar"
          }
        }
      }
    )
  end

  def test_invalid_loglevel
    @transport.client_message(
      jsonrpc: "2.0",
      id: 1,
      method: "logging/setLevel",
      params: {
        level: "invalid"
      }
    )

    @transport.process_message

    assert_equal "info", @server.logging_verbosity

    assert_last_response(
        "jsonrpc": "2.0",
        "id": 1,
        "error": {
          "code": -32602,
          "message": "Invalid loglevel"
        }
    )
  end

  def test_level_is_configurable
    server = RubyMCP::Server.new(logging_verbosity: "debug")
    assert_equal "debug", server.logging_verbosity

    server = RubyMCP::Server.new(logging_verbosity: "error")
    assert_equal "error", server.logging_verbosity

    server = RubyMCP::Server.new
    assert_equal "info", server.logging_verbosity
  end
end
