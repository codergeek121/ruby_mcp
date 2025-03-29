module RubyMCP
  class Transport
    class Stdio < Transport
      def start
        @running = true

        while @running
          begin
            line = $stdin.gets

            break if line.nil?

            @on_message.call(line.strip)
          rescue StandardError => e
            RubyMCP.logger.error("Exception: #{e}")
          end
        end

        @on_close.call
      end

      def send(message)
        $stdout.puts(JSON.generate(message))
        $stdout.flush
      end


      def on_close(&block)
        @on_close = block
      end
    end
  end
end
