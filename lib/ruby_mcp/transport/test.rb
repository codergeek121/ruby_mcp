class RubyMCP::Transport::Test < RubyMCP::Transport
  attr_reader :responses
  attr_reader :client_message_queue

  def initialize
    @client_message_queue = []
    @responses = []
  end

  def start
    @running = true
  end

  def enqueue(message)
    @responses << JSON.generate(message)
  end

  def client_message(message)
    @client_message_queue << JSON.generate(message)
  end

  def process_message
    @on_message.call(@client_message_queue.shift)
  end
end
