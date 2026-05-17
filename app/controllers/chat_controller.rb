class ChatController < ApplicationController
  include ChatFormatterHelper

  def analyze
    question = params[:question]
    file_id = params[:file_id]
    session_id = params[:session_id]
    
    if question.blank?
      return render json: { error: "Question is required" }, status: :bad_request
    end

    @payment_file = nil
    if file_id.present?
      @payment_file = PaymentFile.find_by(id: file_id)
      if @payment_file.nil?
        return render json: { error: "Payment file not found" }, status: :not_found
      end
    end

    session_id ||= generate_session_id(file_id)

    # Call engine
    raw_response = EngineClient.analyze(
      question: question,
      session_id: session_id
    )

    Rails.logger.debug("Raw engine response received")

    # Normalize response structure
    response = normalize_engine_response(raw_response)

    # Format using helper
    formatted_html = format_chat_response(response)

    Rails.logger.debug("Formatted HTML length: #{formatted_html.length}")

    render json: {
      status: response[:status],
      result: response[:result],
      explanation: response[:explanation],
      follow_ups: response[:follow_ups],
      formatted_html: formatted_html,
      session_id: session_id
    }

  rescue StandardError => e
    Rails.logger.error("ChatController Error: #{e.message}")
    Rails.logger.error("Backtrace: #{e.backtrace.join("\n")}")
    render json: {
      error: "Server error",
      explanation: "An error occurred processing your question.",
      follow_ups: [],
      confidence: 0
    }, status: :internal_server_error
  end

  private

  def generate_session_id(file_id)
    if file_id.present?
      "file_#{file_id}_#{Time.now.to_i}"
    else
      "session_#{Time.now.to_i}_#{SecureRandom.hex(4)}"
    end
  end

  def normalize_engine_response(raw_response)
    Rails.logger.debug("=== Normalizing Engine Response ===")

    # If already has proper structure, return as-is
    if raw_response[:result].present?
      Rails.logger.debug("✓ Response already has :result field")
      return raw_response
    end

    explanation = raw_response[:explanation]
    Rails.logger.debug("Explanation class: #{explanation.class}")

    # If explanation is a string, we need to parse it
    if explanation.is_a?(String)
      Rails.logger.debug("Explanation is string, parsing...")

      begin
        # Unescape the quotes
        unescaped = explanation.gsub('\\"', '"')
        Rails.logger.debug("Unescaped sample: #{unescaped[0..100]}...")

        # Evaluate to get hash
        parsed = eval(unescaped)
        Rails.logger.debug("Eval succeeded. Parsed class: #{parsed.class}")
        Rails.logger.debug("Parsed result class: #{parsed[:result].class}")

        # ← THE FIX IS HERE
        if parsed.is_a?(Hash) && parsed[:status].present?
          Rails.logger.debug("✓ Successfully parsed and normalized")
          return parsed
        end

      rescue StandardError => e
        Rails.logger.error("✗ Parse failed: #{e.class} - #{e.message}")
      end
    end

    Rails.logger.warn("Could not normalize - returning original")
    raw_response
  end
end