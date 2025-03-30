class RubyMCP::Requests::ResourcesTemplatesList < RubyMCP::Request
  def allowed_in_lifecycle?(lifecycle)
    lifecycle.operation_phase?
  end
end
