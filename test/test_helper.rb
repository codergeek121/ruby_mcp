# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "ruby_mcp"

class ServerTest < Minitest::Test
  def setup
    @server = RubyMCP::Server.new
    @transport = RubyMCP::Transport::Test.new
    @logger = RubyMCP.logger.reopen(StringIO.new) # silence logs
    @server.connect(@transport)
  end

  private

  def assert_last_response(exp)
    assert_equal(exp, JSON.parse(@transport.responses.last, symbolize_names: true))
  end

  def start_operation_phase
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
    @transport.client_message(
      id: 1337,
      jsonrpc: "2.0",
      method: "notifications/initialized"
    )
    @transport.process_message
  end
end

module OperationPhase
  def setup
    super
    start_operation_phase
  end
end

require "minitest/autorun"
