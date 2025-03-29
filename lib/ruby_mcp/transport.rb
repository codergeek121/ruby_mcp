module RubyMCP
  class Transport
    def close
      @running = false
    end

    def on_message(&block)
      @on_message = block
    end

    def on_close(&block)
      @on_close = block
    end
  end
end
