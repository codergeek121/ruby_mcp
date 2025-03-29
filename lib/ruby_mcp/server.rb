module RubyMCP
  class Server
    include Capabilities::Logging

    attr_reader :lifecycle, :prompts, :resources

    def initialize(logging_verbosity: "info")
      @lifecycle = Lifecycle.new
      @prompts = Prompts.new
      @resources = Resources.new

      @default_logging_verbosity = logging_verbosity
    end

    def connect(transport)
      @transport = transport

      setup_trap
      setup_message_handler
      setup_close_handler
      start_transport
    end

    def add_prompt(...)
      @prompts.add(...)
    end

    def add_resource(...)
      @resources.add(...)
    end

    def send_message(message)
      RubyMCP.logger.debug "S -> C : #{message}"
      @transport.send(message)
    end

    def answer(request, result)
      send_answer(request, result:)
    end

    def error(request, error)
      send_answer(request, error:)
    end

    private

    def send_answer(request, **message)
      send_message(
        id: request.id,
        jsonrpc: "2.0",
        **message
      )
    end

    def setup_trap
      trap("INT") do
        @transport.close
        exit
      end
    end

    def setup_message_handler
      @transport.on_message do |message|
        request = Requests.parse(message)
        handler = Handlers.parse(message)

        RubyMCP.logger.debug "C -> S : #{request.method}"

        handler.handle(self, request) if request.allowed_in_lifecycle?(@lifecycle)
      end
    end

    def setup_close_handler
      @transport.on_close do
        RubyMCP.logger.info "Server stopped"
      end
    end

    def start_transport
      RubyMCP.logger.info("Server connecting with #{@transport.class}")
      @transport.start
    end
  end
end
