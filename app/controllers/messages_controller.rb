# frozen_string_literal: true

class MessagesController < ApplicationController
  before_action :set_messageable

  def create
    @message = @messageable.messages.build(message_params)
    @message.user = Current.user

    if @message.save
      # Broadcast the new message to all participants
      case @messageable
      when DirectMessageThread
        @messageable.participants.each do |participant|
          Turbo::StreamsChannel.broadcast_append_to(
            "user_#{participant.user_id}_messages",
            target: "thread_#{@messageable.id}_messages",
            html: render_component_to_string(Components::MessageItem.new(message: @message))
          )
        end
      end

      # Clear the form via Turbo Stream
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            'new_message_form',
            html: render_component_to_string(Components::MessageForm.new(messageable: @messageable))
          )
        end
      end
    else
      # Re-render the form with errors
      render turbo_stream: turbo_stream.replace(
        'new_message_form',
        html: render_component_to_string(Components::MessageForm.new(messageable: @messageable))
      )
    end
  end

  private

  def render_component_to_string(component)
    ApplicationController.render(component)
  end

  def set_messageable
    if params[:direct_message_thread_id]
      @messageable = DirectMessageThread.find(params[:direct_message_thread_id])
      # Verify current user is a participant
      unless @messageable.participant?(Current.user)
        redirect_to direct_message_threads_path, alert: "You don't have access to this conversation"
      end
    else
      # Handle other messageable types if needed (e.g., channels)
      raise ActiveRecord::RecordNotFound
    end
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
