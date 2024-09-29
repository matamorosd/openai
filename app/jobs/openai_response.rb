class OpenaiResponse < ActiveJob::Base
  queue_as :default

  def perform(chat)
    @chat = chat
    call_openai
  end

  private

    def call_openai
      client = OpenAI::Client
        .new(access_token: Rails.application.credentials.openai_access_token, log_errors: true)

      client.chat(
        parameters: {
          model: "gpt-3.5-turbo",
          messages: @chat.message_hashes,
          temperature: 0.8,
          stream: stream_proc
        }
      )

    end

    def stream_proc
      message_content = ""

      proc do |chunk, _bytesize|
        Rails.logger.info "Received chunk: #{chunk.inspect}"
        if chunk.dig("choices", 0, "finish_reason") == "stop"
          @chat.messages.create(role: "assistant", body: message_content)
        else
          text = chunk.dig("choices", 0, "delta", "content")
          message_content += text unless text.nil?
        end
      end
    end
end
