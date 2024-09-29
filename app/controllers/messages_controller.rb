class MessagesController < ApplicationController
  before_action :find_chat

  def create
    @message = Message.create(
      message_params.merge(chat: @chat, role: "user")
    )

    OpenaiResponse.perform_later(@chat)

    respond_to(&:turbo_stream)
  end

  private

    def message_params
      params.require(:message).permit(:body)
    end

    def find_chat
      @chat = current_user.chats.find(params[:chat_id])
    end
end
