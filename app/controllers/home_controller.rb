# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render Views::Home::Index.new(realms:, pinned_realms:, my_realms:, direct_messages:, activities:)
  end

  def show
  end

  private

  def realms
    @realms ||= Realm.left_joins(:memberships)
      .select('realms.*, COUNT(memberships.id) as member_count')
      .where(is_public: true)
      .group('realms.id')
      .order('member_count DESC')
      .limit(6)
  end

  def pinned_realms
    @pinned_realms ||= Current.user.realms
      .joins(:memberships)
      .where(memberships: { user_id: Current.user.id })
      .order('memberships.joined_at ASC')
      .limit(2)
  end

  def my_realms
    @my_realms ||= Current.user.realms
      .where.not(id: pinned_realms.pluck(:id))
      .limit(5)
  end

  def direct_messages
    @direct_messages ||= DirectMessageThread.joins(:participants)
      .where(direct_message_participants: { user_id: Current.user.id })
      .joins('LEFT JOIN messages ON messages.messageable_type = \'DirectMessageThread\' AND messages.messageable_id = direct_message_threads.id')
      .select('direct_message_threads.*, MAX(messages.created_at) as last_message_at')
      .group('direct_message_threads.id')
      .order('last_message_at DESC NULLS LAST')
      .limit(3)
  end

  def activities
    @activities ||= Activity.includes(:user)
      .order(created_at: :desc)
      .limit(5)
  end
end
