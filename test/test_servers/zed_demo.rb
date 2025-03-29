add_prompt(
  name: "ruby_example",
  description: "Example usage of a method",
  arguments: [
    {
      name: "snippet",
      description: "small ruby snippet",
      required: true,
      completions: ->(*) { [ "String#split", "Array#join", "tally", "unpack" ] }
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
              Only answer with a single code snippet and a one-liner explanation.
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
