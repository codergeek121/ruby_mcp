class RubyMCP::Requests::ResourcesList < RubyMCP::Request
  def allowed_in_lifecycle?(lifecycle)
    lifecycle.operation_phase?
  end
end
