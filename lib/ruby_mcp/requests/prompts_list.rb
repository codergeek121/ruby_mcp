class RubyMCP::Requests::PromptsList < RubyMCP::Request
  def allowed_in_lifecycle?(lifecycle)
    lifecycle.operation_phase?
  end
end
