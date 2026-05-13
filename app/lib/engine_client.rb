# Wrapper for calling AI Analyst Engine
# Handles HTTP communication, error handling, response parsing

class EngineClient
  # Configuration
  ENGINE_URL = ENV['ENGINE_URL'] || 'http://engine:4567'
  TIMEOUT = ENV['ENGINE_TIMEOUT'].to_i || 30

  # Main method: Call engine analyze endpoint
  def self.analyze(question:, context:)
    # Validate inputs
    raise ArgumentError, "Question cannot be empty" if question.blank?
    raise ArgumentError, "Context cannot be empty" if context.blank?

    # Build request payload
    payload = {
      question: question,
      context: context
    }

    # Call engine API
    response = HTTParty.post(
      "#{ENGINE_URL}/analyze",
      body: payload.to_json,
      headers: { 'Content-Type' => 'application/json' },
      timeout: TIMEOUT
    )

    # Parse and return response
    parse_response(response)
  rescue Timeout::Error
    handle_timeout_error
  rescue StandardError => e
    handle_generic_error(e)
  end

  private

  # Parse successful response from engine
  def self.parse_response(response)
    if response.success?
      JSON.parse(response.body, symbolize_names: true)
    else
      {
        error: "Engine returned error: #{response.code}",
        explanation: "The engine encountered an error processing your question.",
        follow_ups: [],
        confidence: 0
      }
    end
  end

  # Handle timeout error
  def self.handle_timeout_error
    {
      error: "Engine request timed out",
      explanation: "The engine is taking too long to respond. Please try again.",
      follow_ups: [],
      confidence: 0
    }
  end

  # Handle generic error
  def self.handle_generic_error(error)
    Rails.logger.error("EngineClient Error: #{error.message}")
    {
      error: "Engine communication error: #{error.message}",
      explanation: "Sorry, I couldn't reach the analysis engine right now. Please try again.",
      follow_ups: [],
      confidence: 0
    }
  end
end