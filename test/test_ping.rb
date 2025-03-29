require "test_helper"

class TestServerInitialization < ServerTest
  def test_ping_answer
    @transport.client_message({
      id: 1337,
      jsonrpc: "2.0",
      method: "ping",
      params: {}
    })

    @transport.process_message

    assert_last_response(
      id: 1337,
      jsonrpc: "2.0",
      result: {}
    )
  end
end
