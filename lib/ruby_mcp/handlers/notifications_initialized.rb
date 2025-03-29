class RubyMCP::Handlers::NotificationsInitialized
  def handle(server, request)
    server.lifecycle.operation_phase!
    RubyMCP.logger.info "Operation Phase started"
  end
end
