class RubyMCP::Requests::CompletionComplete < RubyMCP::Request
  def ref
    @json.dig("params", "ref")
  end

  def argument_name
    @json.dig("params", "argument", "name")
  end

  def param
    {
      @json.dig("params", "argument", "name").to_sym => @json.dig("params", "argument", "value")
    }
  end

  def allowed_in_lifecycle?(lifecycle)
    lifecycle.operation_phase?
  end
end
