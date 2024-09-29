class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  def message_hashes
    all_messages = messages.all.map { |m| { role: m.role, content: m.body } }
    all_messages.unshift(system_message)
  end

  private

    def system_message
      {
        "role": "system",
        "content": system_prompt
      }
    end

    def system_prompt
      <<~PROMPT
        You are a helpful assistant, trying to enterain the user.
      PROMPT
    end
end

