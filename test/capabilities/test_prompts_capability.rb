require "test_helper"

class TestPromptsCapability < ServerTest
  include OperationPhase

  def test_prompt_list
    @server.add_prompt(
      name: "refactor",
      description: "Review this code",
      arguments: [
        {
          name: "code",
          description: "code to review",
          required: true,
          completions: ->(*) { [ "some", "completion", "value" ] }
        }
      ],
      result: ->(code:) {
        {
          description: "Review this #{code} code",
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
      jsonrpc: "2.0",
      id: 1,
      method: "prompts/list",
      params: {}
    )

    @transport.process_message

    assert_last_response(
      id: 1,
      jsonrpc: "2.0",
      result: {
        prompts: [
          {
            name: "refactor",
            description: "Review this code",
            arguments: [
              {
                name: "code",
                description: "code to review",
                required: true
              }
            ]
          }
        ]
      }
    )
  end

  def test_prompt_get
    @server.add_prompt(
      name: "refactor",
      description: "Refactor this code",
      arguments: [
        {
          name: "code",
          description: "code to review",
          required: true,
          completions: ->(*) { [ "some", "completion", "value" ] }
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
      jsonrpc: "2.0",
      id: 1,
      method: "prompts/get",
      params: {
        name: "refactor",
        arguments: {
          code: "THE_CODE"
        }
      }
    )

    @transport.process_message

    assert_last_response(
      id: 1,
      jsonrpc: "2.0",
      result: {
        description: "Refactor this THE_CODE code",
        messages: [
          {
            role: "user",
            content: {
              type: "text",
              text: "The code: THE_CODE"
            }
          }
        ]
      }
    )
  end

  def test_prompt_get_invalid_prompt_name
    @server.add_prompt(
      name: "refactor",
      description: "Review this code",
      arguments: [],
      result: ->() {
        {
          description: "demo",
          messages: [
            {
              role: "user",
              content: {
                type: "text",
                text: "demo"
              }
            }
          ]
        }
      },
    )

    @transport.client_message(
      jsonrpc: "2.0",
      id: 1,
      method: "prompts/get",
      params: {
        name: "invalid_name",
        arguments: {}
      }
    )

    @transport.process_message

    assert_last_response(
      jsonrpc: "2.0",
      id: 1,
      error: {
        code: -32602,
        message: "Invalid params"
      }
    )
  end

  def test_prompt_get_missing_required_argument
    @server.add_prompt(
      name: "refactor",
      description: "Review this code",
      arguments: [
        {
          name: "code",
          description: "code to review",
          required: true,
          completions: ->(*) { [ "some", "completion", "value" ] }
        }
      ],
      result: ->() {
        {
          description: "demo",
          messages: [
            {
              role: "user",
              content: {
                type: "text",
                text: "demo"
              }
            }
          ]
        }
      },
    )

    @transport.client_message(
      jsonrpc: "2.0",
      id: 1,
      method: "prompts/get",
      params: {
        name: "refactor",
        arguments: {}
      }
    )

    @transport.process_message

    assert_last_response(
      jsonrpc: "2.0",
      id: 1,
      error: {
        code: -32602,
        message: "Missing required param"
      }
    )
  end

  def test_prompt_get_missing_required_argument_with_given_optional
    @server.add_prompt(
      name: "refactor",
      description: "Review this code",
      arguments: [
        {
          name: "code",
          description: "code to review",
          required: true,
          completions: ->(*) { [ "some", "completion", "value" ] }
        },
        {
          name: "language",
          description: "Programming language",
          required: false,
          completions: ->(*) { [ "some", "completion", "value" ] }
        }
      ],
      result: ->() {
        {
          description: "demo",
          messages: [
            {
              role: "user",
              content: {
                type: "text",
                text: "demo"
              }
            }
          ]
        }
      },
    )

    @transport.client_message(
      jsonrpc: "2.0",
      id: 1,
      method: "prompts/get",
      params: {
        name: "refactor",
        arguments: {
          language: "Ruby"
        }
      }
    )

    @transport.process_message

    assert_last_response(
      jsonrpc: "2.0",
      id: 1,
      error: {
        code: -32602,
        message: "Missing required param"
      }
    )
  end

  def test_prompt_get_missing_required_argument_with_multiple_required_args
    @server.add_prompt(
      name: "refactor",
      description: "Review this code",
      arguments: [
        {
          name: "code",
          description: "code to review",
          required: true,
          completions: ->(*) { [ "some", "completion", "value" ] }
        },
        {
          name: "language",
          description: "Programming language",
          required: true,
          completions: ->(*) { [ "some", "completion", "value" ] }
        }
      ],
      result: ->() {
        {
          description: "demo",
          messages: [
            {
              role: "user",
              content: {
                type: "text",
                text: "demo"
              }
            }
          ]
        }
      },
    )

    @transport.client_message(
      jsonrpc: "2.0",
      id: 1,
      method: "prompts/get",
      params: {
        name: "refactor",
        arguments: {
          language: "Ruby"
        }
      }
    )

    @transport.process_message

    assert_last_response(
      jsonrpc: "2.0",
      id: 1,
      error: {
        code: -32602,
        message: "Missing required param"
      }
    )
  end
end
