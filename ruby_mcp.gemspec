# frozen_string_literal: true

require_relative "lib/ruby_mcp/version"

Gem::Specification.new do |spec|
  spec.name = "ruby_mcp"
  spec.version = RubyMCP::VERSION
  spec.authors = [ "Niklas Häusele" ]
  spec.email = [ "niklas.haeusele@hey.com" ]

  spec.summary = "Low-level MCP protocol sdk for Ruby."
  spec.homepage = "https://github.com/codergeek121/ruby_mcp"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = [ "lib" ]

  spec.add_dependency "zeitwerk", '~> 2.7', '>= 2.7.2'
end
