module RubyMCP
  class Transport
    class Stdio < Transport
      def initialize
        @queue = Queue.new
      end

      def start
        @running = true
        start_message_worker

        while @running
          begin
            line = $stdin.gets

            break if line.nil?

            @queue << [ :incoming, line.strip ]
          rescue StandardError => e
            RubyMCP.logger.error("Exception: #{e}")
          end
        end

        @on_close.call
      end

      def enqueue(message)
        @queue << [ :outgoing, JSON.generate(message) ]
      end


      def on_close(&block)
        @on_close = block
      end

      private

      def start_message_worker
        sleep 0.2
        RubyMCP.logger.info("Starting worker thread")
        @worker = Thread.new do
          while @running
            type, message = @queue.pop

            if type == :incoming
              @on_message.call(message)
            else
              $stdout.puts(message)
              $stdout.flush
            end
          end
        end
      end
    end
  end
end
