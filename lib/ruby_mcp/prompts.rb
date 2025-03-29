module RubyMCP
  class Prompts
    def initialize
      @prompts = {}
    end

    def add(name:, description:, arguments: [], result: Proc.new { [] }, completions: nil)
      @prompts[name] = { description:, arguments:, result:, completions: }
    end

    def list
      @prompts.map do |name, details|
        {
          name: name,
          description: details[:description],
          arguments: details[:arguments].map { _1.slice(:name, :description, :required) }
        }
      end
    end

    def find_by_name(name)
      @prompts[name]
    end
  end
end
