  class MessagesController < ApplicationController
    before_action :find_conversation

    def index
      @conversation.messages.where("user_id != ? AND read = ?", current_user.id, false).update_all(read: true)
      # if @messages.length > 10
      #   @over_ten = true
      #   @messages = @messages[-10..-1]
      # end
  
      # if params[:m]
      #   @over_ten = false
      #   @messages = @conversation.messages
      # end
      @message = @conversation.messages.new
    end
  
    def create
      @message = @conversation.messages.new(message_params)
      @message.user = current_user
  
      if @message.save
        ActionCable.server.broadcast "messages", { conversation_id: @conversation.id }
        redirect_to conversation_messages_path(@conversation)
      end
    end
  
    private
      def message_params
        params.require(:message).permit(:body, :user_id)
      end

      def find_conversation
        @conversation = Conversation.find(params[:conversation_id])
      end
  end