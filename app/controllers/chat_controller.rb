class ChatController < ApplicationController
  def analyze
    question = params[:question]
    file_id = params[:file_id]
    session_id = params[:session_id]
    
    # Only question is required
    if question.blank?
      return render json: { error: "Question is required" }, status: :bad_request
    end

    # file_id is optional - load file only if provided
    @payment_file = nil
    if file_id.present?
      @payment_file = PaymentFile.find_by(id: file_id)
      if @payment_file.nil?
        return render json: { error: "Payment file not found" }, status: :not_found
      end
    end

    # Generate session ID if not provided
    session_id ||= generate_session_id(file_id)

    # Call engine with question and session
    # Works with or without file context
    response = EngineClient.analyze(
      question: question,
      session_id: session_id
    )

    # Add session_id to response for follow-ups
    response[:session_id] = session_id

    render json: response
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
end
