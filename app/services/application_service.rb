class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def call
    validate_params!
  end

  def validate_params!
  end
end