class RubyMCP::Requests::ResourcesRead < RubyMCP::Request
  def params
    @json.dig("params")
  end

  def uri
    params["uri"]
  end

  def allowed_in_lifecycle?(lifecycle)
    lifecycle.operation_phase?
  end
end
