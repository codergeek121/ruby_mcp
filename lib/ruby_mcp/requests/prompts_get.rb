class RubyMCP::Requests::PromptsGet < RubyMCP::Request
  attr_reader :json

  def name
    @json.dig("params", "name")
  end

  def arguments
    @json.dig("params", "arguments").transform_keys(&:to_sym)
  end

  def allowed_in_lifecycle?(lifecycle)
    lifecycle.operation_phase?
  end
end
