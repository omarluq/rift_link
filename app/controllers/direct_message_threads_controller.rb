# frozen_string_literal: true

class DirectMessageThreadsController < ApplicationController
  before_action :set_thread, only: [:show]

  def index
    @threads = DirectMessageThread
      .joins(:participants)
      .where(direct_message_participants: { user_id: Current.user.id })
      .includes(:participants => :user)
      .distinct
    render Views::DirectMessageThreads::Index.new(threads: @threads)
  end

  def show
    @messages = @thread.messages.includes(:user).order(created_at: :asc)
    render Views::DirectMessageThreads::Show.new(thread: @thread, messages: @messages)
  end

  def create
    @user = User.find(params[:user_id])

    existing_thread = DirectMessageThread.joins(:participants)
      .where(direct_message_participants: { user_id: Current.user.id })
      .joins("INNER JOIN direct_message_participants other_participant
              ON other_participant.direct_message_thread_id = direct_message_threads.id
              AND other_participant.user_id = ?", @user.id)
      .first

    if existing_thread
      redirect_to direct_message_thread_path(existing_thread)
      return
    end

    @thread = DirectMessageThread.create!

    DirectMessageParticipant.create!(direct_message_thread: @thread, user: Current.user)
    DirectMessageParticipant.create!(direct_message_thread: @thread, user: @user)

    redirect_to direct_message_thread_path(@thread)
  end

  private

  def set_thread
    @thread = DirectMessageThread.find(params[:id])
    unless @thread.participant?(Current.user)
      redirect_to direct_message_threads_path, alert: "You don't have access to this conversation"
    end
  end
end
