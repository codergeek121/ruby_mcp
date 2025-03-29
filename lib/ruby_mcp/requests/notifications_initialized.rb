class RubyMCP::Requests::NotificationsInitialized < RubyMCP::Request
  def allowed_in_lifecycle?(lifecycle)
    lifecycle.initialize_response_sent?
  end
end
