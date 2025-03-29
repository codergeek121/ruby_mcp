require "test_helper"
require "open3"
require "json"
require "timeout"

module Support
  def setup
    @stdin, @stdout, @stderr = Open3.popen3("ruby test/test_servers/demo1.rb")
  end

  def teardown
    @stdin.puts(nil) rescue nil
    @stdin.close rescue nil
    @stdout.close rescue nil
    @stderr.close rescue nil
  end

  private

  def initialize_server
    send_request("initialize", {})
    get_response
  end

  def send_request(method, params)
    request_id = rand(10000)
    request = {
      id: request_id,
      jsonrpc: "2.0",
      method: method,
      params: params
    }
    @stdin.puts(JSON.generate(request))
    request_id
  end

  def get_response
    Timeout.timeout(5) do
      response_text = @stdout.gets
      return nil unless response_text
      JSON.parse(response_text)
    end
  rescue Timeout::Error
    flunk "Timed out waiting for server response"
  end
end

class TestRubyMcp < Minitest::Test
  include Support

  def test_answers_initialization
    request_id = send_request("initialize", {})
    response = get_response

    assert_equal({
      "id" => request_id,
      "jsonrpc"=>"2.0",
      "result"=> {
        "protocolVersion"=>"2024-11-05",
        "capabilities" => {
          "logging"=>{},
          "prompts"=> {
            "listChanged"=>true
          },
          "resources"=>{},
          "tools"=> { "listChanged"=>true }
        },
        "serverInfo" => {
          "name"=>"RubyMCP",
          "version"=>"0.1.0"
        }
      }
    }, response)
  end
end
