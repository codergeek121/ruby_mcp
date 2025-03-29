class RubyMCP::Request
  def initialize(json)
    @json = json
  end

  def method
    @json["method"]
  end

  def id
    @json["id"]
  end

  def allowed_in_lifecycle?(lifecycle)
    true
  end
end
