class Message < ApplicationRecord
  include ActionView::RecordIdentifier

  belongs_to :chat

  enum role: { system: 0, assistant: 10, user: 20 }

  validates :body, presence: true

  after_create_commit -> { broadcast_created }
  after_update_commit -> { broadcast_updated }

  private

    def broadcast_created
      broadcast_append_later_to(
        :chat_messages,
        partial: "messages/message",
        locals: { message: self },
        target: dom_id(chat, "messages")
      )
    end

    def broadcast_updated
      broadcast_append_to(
        :chat_messages,
        partial: "messages/message",
        locals: { message: self },
        target: dom_id(chat, "messages")
      )
    end
end
