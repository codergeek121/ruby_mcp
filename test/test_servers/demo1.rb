#!/usr/bin/env ruby

require "bundler/setup"
require "ruby_mcp"

server = RubyMCP::Server.new
transport = RubyMCP::Transport::Stdio.new
server.connect(transport)
