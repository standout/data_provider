class MockProvider
  Response = Struct.new(:data, :expires_at)

  attr_reader :options

  def initialize(options = {})
    @options = options
  end

  def fetch
    expires_in = options[:expires_in]
    Response.new(options[:data], (expires_in ? Time.now + expires_in : nil))
  end
end
