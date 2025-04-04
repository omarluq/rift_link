# frozen_string_literal: true

class DirectMessageChannel < ApplicationCable::Channel
  def subscribed
    if params[:thread_id].present?
      thread = DirectMessageThread.find(params[:thread_id])
      if thread.participant?(current_user)
        stream_for thread
      else
        reject
      end
    end

    # Also subscribe to user-specific channel for all their direct messages
    stream_from "user_#{current_user.id}_messages"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def typing
    thread = DirectMessageThread.find(params[:thread_id])
    return unless thread.participant?(current_user)

    # Broadcast typing indicator to other participants
    thread.participants.each do |participant|
      next if participant.user_id == current_user.id

      ActionCable.server.broadcast(
        "user_#{participant.user_id}_messages",
        {
          action: 'typing',
          user_id: current_user.id,
          username: current_user.username,
          thread_id: thread.id,
        }
      )
    end
  end

  def stopped_typing
    thread = DirectMessageThread.find(params[:thread_id])
    return unless thread.participant?(current_user)

    # Broadcast stopped typing to other participants
    thread.participants.each do |participant|
      next if participant.user_id == current_user.id

      ActionCable.server.broadcast(
        "user_#{participant.user_id}_messages",
        {
          action: 'stopped_typing',
          user_id: current_user.id,
          thread_id: thread.id,
        }
      )
    end
  end
end
