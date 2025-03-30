module RubyMCP::Capabilities::Prompts
  def add_prompt(...)
    @prompts.add(...)

    RubyMCP.logger.info(@transport)
    send_prompts_list_changed if @transport
  end

  private

  def send_prompts_list_changed
    @transport.enqueue(jsonrpc: "2.0", method: "notifications/prompts/list_changed")
  end
end
