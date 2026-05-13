class ChatController < ApplicationController
  def analyze
    question = params[:question]
    file_id = params[:file_id]
    
    if question.blank?
      return render json: { error: "Question is required" }, status: :bad_request
    end

    if file_id.blank?
      return render json: { error: "File ID is required" }, status: :bad_request
    end

    # Load payment file
    @payment_file = PaymentFile.find_by(id: file_id)
    if @payment_file.nil?
      return render json: { error: "Payment file not found" }, status: :not_found
    end

    # Generate or retrieve session ID (use file_id + timestamp)
    session_id = params[:session_id] || generate_session_id(file_id)

    # Call engine with session for multi-turn support
    response = EngineClient.analyze(
      question: question,
      session_id: session_id
    )

    # Add session_id to response for follow-ups
    response[:session_id] = session_id

    render json: response
  rescue StandardError => e
    Rails.logger.error("ChatController Error: #{e.message}")
    render json: {
      error: "Server error",
      explanation: "An error occurred processing your question.",
      follow_ups: [],
      confidence: 0
    }, status: :internal_server_error
  end

  private

  def generate_session_id(file_id)
    # Session ID based on file_id for consistency
    "file_#{file_id}_#{Time.now.to_i}"
  end
end