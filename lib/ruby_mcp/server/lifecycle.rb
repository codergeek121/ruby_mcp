class RubyMCP::Server::Lifecycle
  STATES = [ :initialization_pending, :initialize_response_sent, :operation_phase_started ]

  def initialize
    @current = 0
  end

  def initialize_response_sent!
    @current = 1
  end

  def operation_phase!
    @current = 2
  end

  def operation_phase?
    current == :operation_phase_started
  end

  def initialization_pending?
    current == :initialization_pending
  end

  def initialize_response_sent?
    current == :initialize_response_sent
  end

  private

  def current
    STATES[@current]
  end
end
