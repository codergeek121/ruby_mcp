require "test_helper"

class TestCompletion < ServerTest
  include OperationPhase

  def test_completion_complete
    @server.add_prompt(
      name: "refactor",
      description: "Review this code",
      arguments: [
        {
          name: "code",
          description: "code to review",
          required: true,
          completions: ->(code:) { [ "some", "completion", "value", code ] }
        }
      ],
      result: ->(code:) {
        {
          description: "Refactor this #{code} code",
          messages: [
            {
              role: "user",
              content: {
                type: "text",
                text: "The code: #{code}"
              }
            }
          ]
        }
      },
    )

    @transport.client_message(
      method: "completion/complete",
      params: {
        argument: {
          name: "code",
          value: "THE_CODE"
        },
        ref: {
          type: "ref/prompt",
          name: "refactor"
        }
      }
    )

    @transport.process_message

    assert_last_response(
      id: nil,
      jsonrpc: "2.0",
      result: {
        completion: {
          hasMore: false,
          total: 4,
          values: [ "some", "completion", "value", "THE_CODE" ]
        }
      }
    )
  end
end
