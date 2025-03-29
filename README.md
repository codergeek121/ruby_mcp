# RubyMCP - Build a MCP Server with Ruby

A low-level Model-Context-Protocol implementation for Ruby. Supports [prompts](https://spec.modelcontextprotocol.io/specification/2025-03-26/server/prompts/) and [completions](https://spec.modelcontextprotocol.io/specification/2024-11-05/server/utilities/completion/#protocol-messages).

```ruby
server = RubyMCP::Server.new

server.add_prompt(
  name: "ruby_example",
  description: "Example usage of a method",
  arguments: [
    {
      name: "snippet",
      description: "small ruby snippet",
      required: true,
      completions: ->(*) { [ 'String#split', 'Array#join', 'tally', 'unpack' ] }
    }
  ],
  result: ->(snippet:) {
    {
      description: "Explain '#{snippet}'",
      messages: [
        {
          role: "user",
          content: {
            type: "text",
            text: <<~TXT
              You're a coding assistant in the editor zed.
              You give one practical example for the given ruby method.
              Only answer with a single code snippet and one line of explanation.
              For example:
              INPUT: '''String#split'''
              OUTPUT: 'abc'.split('') # ['a', 'b', 'c']\n Splits the string"
            TXT
          }
        },
        {
          role: "user",
          content: {
            type: "text",
            text: "INPUT: '''#{snippet}'''"
          }
        }
      ]
    }
  },
)

transport = RubyMCP::Transport::Stdio.new
server.connect(transport)
```

## Logging

RubyMCP supports [mcp logging](https://spec.modelcontextprotocol.io/specification/2025-03-26/server/utilities/logging/). Each logging level has a corresponding method prefixed with `send_` and suffixed with `_log_message`.

- **Debug Level:**
  ```ruby
  server.send_debug_log_message({ text: "Debug information" })
  ```

- **Info Level:**
  ```ruby
  server.send_info_log_message({ text: "Informational message" })
  ```

A MCP client can configure change the log severity or it can be set during server creation. The default is "info".

```ruby
server = Server.new(logging_verbosity: "debug")
```
