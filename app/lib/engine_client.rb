# Wrapper for calling AI Analyst Engine
# Handles HTTP communication, error handling, response parsing

class EngineClient
  ENGINE_URL = ENV['ENGINE_URL'] || 'http://engine:4567'
  TIMEOUT = ENV['ENGINE_TIMEOUT'].to_i || 30

  def self.analyze(question:, session_id: nil)
    raise ArgumentError, "Question cannot be empty" if question.blank?

    payload = {
      question: question,
      session_id: session_id || generate_session_id
    }

    response = HTTParty.post(
      "#{ENGINE_URL}/analyze",
      body: payload.to_json,
      headers: { 'Content-Type' => 'application/json' },
      timeout: TIMEOUT
    )

    parse_response(response)
  rescue Timeout::Error
    handle_timeout_error
  rescue StandardError => e
    handle_generic_error(e)
  end

  private

  def self.generate_session_id
    # Generate unique session ID for stateless queries
    # For multi-turn, will be overridden by file_id in controller
    "session_#{Time.now.to_i}_#{SecureRandom.hex(4)}"
  end

  def self.parse_response(response)
    if response.success?
      # Engine wraps response in { result: {...} }
      data = JSON.parse(response.body, symbolize_names: true)
      result = data[:result]

      # Map engine response to chat format
      {
        explanation: format_explanation(result),
        follow_ups: extract_follow_ups(result),
        confidence: extract_confidence(result),
        status: extract_status(result)
      }
    else
      {
        explanation: "The engine encountered an error.",
        follow_ups: [],
        confidence: 0,
        status: "error"
      }
    end
  end

  def self.format_explanation(result)
    # Engine returns explanation as string or object
    case result
    when String
      result
    when Hash
      result[:explanation] || result.to_s
    else
      result.to_s
    end
  end

  def self.extract_follow_ups(result)
    # Engine may return follow_ups array
    case result
    when Hash
      result[:follow_ups] || result[:follow_up_projections] || []
    else
      []
    end
  end

  def self.extract_confidence(result)
    # Engine may include confidence/reliability
    case result
    when Hash
      result[:confidence] || result[:reliability] || 0.85
    else
      0.85
    end
  end

  def self.extract_status(result)
    # Extract status from engine response
    case result
    when Hash
      result[:status] || "success"
    else
      "success"
    end
  end

  def self.handle_timeout_error
    {
      explanation: "The engine is taking too long to respond.",
      follow_ups: [],
      confidence: 0,
      status: "timeout"
    }
  end

  def self.handle_generic_error(error)
    Rails.logger.error("EngineClient Error: #{error.message}")
    {
      explanation: "Sorry, I couldn't process your question.",
      follow_ups: [],
      confidence: 0,
      status: "error"
    }
  end
end