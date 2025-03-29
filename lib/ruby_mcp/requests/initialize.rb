class RubyMCP::Requests::Initialize < RubyMCP::Request
  def allowed_in_lifecycle?(lifecycle)
    lifecycle.initialization_pending?
  end
end
